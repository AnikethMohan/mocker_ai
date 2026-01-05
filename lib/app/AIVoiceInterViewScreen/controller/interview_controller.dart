import 'dart:convert';
import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:mocker_ai/Common/GeminiModels/gemini_model_names.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/model/interview_context.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/model/interview_response.dart';
import 'package:mocker_ai/app/UploadResumePage/controller/resume_controller.dart';
import 'package:mocker_ai/routes/routes_name.dart';
import 'package:mocker_ai/routes/routes_pages.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum InterviewState {
  idle,
  initializing,
  speaking,
  listening,
  finshedSpeaking,
  typing, // New state for web
  processing,
  finished,
}

class InterviewController extends GetxController {
  final String interviewerName = 'John';
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText speechToText = SpeechToText();

  final Rx<InterviewState> state = InterviewState.idle.obs;
  final RxList<String> conversationHistory = <String>[].obs;
  final interviewResponse = Rxn<InterviewResponse>();

  final ResumeController _resumeController = Get.find<ResumeController>();
  final InterviewMemory memory = InterviewMemory();
  var isInterViewFinished = false.obs;

  var interviewAnalysisStatus = RxStatus.empty().obs;
  var interviewAnalysis = InterviewAnalysis().obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _initStt();
    if (!kIsWeb) {
      _initStt();
    }
  }

  Future<void> _initTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ], IosTextToSpeechAudioMode.defaultMode);
  }

  Future<void> _initStt() async {
    await speechToText.initialize(
      onStatus: (val) {
        if (val == 'notListening') {
          speechToText.stop();
        }
      },
      onError: (val) {
        if (val.errorMsg == 'notListening') {
          speechToText.stop();
        }
      },
    );
  }

  scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500), // Adjust duration as needed
      curve: Curves.ease, // Choose an appropriate curve
    );
  }

  Future<void> startInterview() async {
    state.value = InterviewState.initializing;
    final initialQuestion = await _generateInitialQuestion();
    conversationHistory.add("AI: $initialQuestion");
    memory.askedQuestions.add(initialQuestion);
    await _speak(initialQuestion, onComplete: () {});
  }

  Future<String> _generateInitialQuestion() async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: GeminiModels.gem25Flash,
    );

    final prompt = [
      Content.text('''
          You are an AI interviewer. Below is the candidate’s information:

          **Resume Details (JSON):**
          ${jsonEncode(_resumeController.resumeResultData.value!.toJson())}

          **Job Description (JSON):**
          ${jsonEncode(_resumeController.jobAnalysisResultData.value?.toJson())}

          Your role:
          - You are a friendly, professional interviewer named "$interviewerName"
          - You must conduct an interview tailored to the candidate's resume and the job description.
          - Begin with a short, warm introduction about who you are.
          - Then ask **one strong first interview question**.
          - The question must:
            • Be relevant to the job description  
            • Reference the candidate’s experience or skills from the resume  
            • Be specific, not generic  
            • Encourage detailed responses (avoid yes/no questions)

          Speech Style:
          - Your question must sound like natural, conversational spoken language.
          - Keep sentences clear, warm, and human-like—not robotic or overly formal..//
          - Use natural phrasing, slight pauses, and tone that feels like real speech.
          - Avoid long, complex sentences. Make  it sound like something a real interviewerwould say aloud.

          Format your output as:
          1. A brief introduction (1-2 sentences).
          2. A single interview question.
    '''),
    ];

    final response = await model.generateContent(prompt);
    return response.text ??
        "I'm sorry, I couldn't generate a question. Could you please tell me about yourself?";
  }

  Future<void> _speak(String text, {VoidCallback? onComplete}) async {
    state.value = InterviewState.speaking;
    try {
      await flutterTts.speak(text);
      state.value = InterviewState.finshedSpeaking;
      if (onComplete != null) {
        onComplete();
      }
    } catch (e) {
      log('$e');
      state.value = InterviewState.finshedSpeaking;
    }
  }

  void listen() {
    state.value = InterviewState.listening;
    speechToText.listen(
      onResult: (result) {
        log(result.recognizedWords);
        log('${result.finalResult}');
        if (result.finalResult) {
          processAnswer(result.recognizedWords);
        }
      },
    );
  }

  Future<void> processAnswer(String answer) async {
    state.value = InterviewState.processing;
    conversationHistory.add("You: $answer");
    scrollDown();
    memory.userResponses.add(answer);

    final nextQuestion = await _generateNextQuestion();

    conversationHistory.add("AI: ${nextQuestion.response}");
    scrollDown();
    memory.askedQuestions.add(nextQuestion.response ?? '');

    if (nextQuestion.isInterviewFinished ?? false) {
      await _speak(
        nextQuestion.response ?? "Thank you for your time.",
        onComplete: () {},
      );
      return;
    }
    await _speak(nextQuestion.response ?? "Sorry, I didn't get that.");
  }

  Future<InterviewResponse> _generateNextQuestion() async {
    final interviewSchema = Schema.object(
      properties: {
        'response': Schema.string(
          description:
              "The interviewer's next question or concluding statement.",
        ),
        'isInterviewFinished': Schema.boolean(
          description:
              "Set to true only when the interview should definitively end.",
        ),
      },
      optionalProperties: ['response', 'isInterviewFinished'],
    );

    final model = FirebaseAI.googleAI().generativeModel(
      model: GeminiModels.gem25Flash,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: interviewSchema,
      ),
    );

    final prompt = [
      Content.text(''' Resume details:
    ${jsonEncode(_resumeController.resumeResultData.value!.toJson())}

    Job Description:
    ${_resumeController.jobDescriptionController.text}

    Interview Memory:
    ${jsonEncode(memory.toJson())}
    '''),
      Content.text('''
        You are a friendly, professional interviewer named "$interviewerName".

        Here is the conversation so far:
        ${memory.toJson()}

                Your task:
               - Identify what topics have already been discussed.
              - Do NOT repeat questions or stay on the same topic unless clarification is needed.
              - Progress the interview naturally by moving to a new relevant topic based on the resume and job description.
              - Cover a variety of areas: experience, technical skills, soft skills, problem-solving, teamwork, leadership, tools/tech stack, culture fit, career goals, etc.
              - Keep the conversation flowing with natural forward momentum.
              - After covering the main topics, provide a concluding statement and set "isInterviewFinished" to true.
              - When you decide the interview is finished, your final spoken response MUST include a friendly closing line that clearly tells the user: 
                "This interview is now finished, and you’ll be redirected to your summary screen where you can review your results."
              - This line should ONLY be said on the final response when `isInterviewFinished` is true.
              - Ask ONLY ONE next question unless you are concluding the interview.


                Speech Style:
                - Your response must sound like natural, conversational spoken language.
                - Keep sentences clear, warm, and human-like—not robotic or overly formal.
                - Use natural phrasing, slight pauses, and tone that feels like real speech.
                - Avoid long, complex sentences. Make it sound like something a real interviewer would say aloud.

                Output Requirements:
                - Output a valid JSON object matching the provided schema.
                - The 'response' field should contain your spoken words.
                - The 'isInterviewFinished' field must be a boolean.
      '''),
    ];

    final response = await model.generateContent(prompt);
    final json = jsonDecode(response.text!);
    log('$json');
    return InterviewResponse.fromJson(json);
  }

  Future<void> analyzeInterview() async {
    interviewAnalysisStatus.value = RxStatus.loading();
    final analysisSchema = Schema.object(
      properties: {
        'overAllPerformance': Schema.number(
          description:
              "Score from 0 to 100 indicating how the overall performance of the candidate was in the interview.",
        ),
        'clarity': Schema.number(
          description:
              "Score from 0 to 100 indicating how clear and understandable the candidate's answers were.",
        ),
        'depth': Schema.number(
          description:
              "Score from 0 to 100 indicating how detailed and thoughtful the answers were.",
        ),
        'structure': Schema.number(
          description:
              "Score from 0 to 100 indicating how well-structured and organized the answers were.",
        ),
        'keyStrengths': Schema.array(
          items: Schema.string(),
          description:
              "Key strengths demonstrated by the candidate during the interview.",
        ),
        'areasToImprove': Schema.array(
          items: Schema.string(),
          description:
              "Specific areas where the candidate can improve their interview responses.",
        ),
        'numberOfQuestionsAnswered': Schema.integer(
          description:
              "Total number of interview questions answered by the user.",
        ),
        'averageResponseLength': Schema.number(
          description: "Average length of user responses measured in words.",
        ),
        'completionRate': Schema.number(
          description:
              "Interview completion rate between 0 and 1 based on how fully the interview was completed.",
        ),
      },
      optionalProperties: [
        'overAllPerformance'
            'clarity',
        'depth',
        'structure',
        'keyStrengths',
        'areasToImprove',
        'numberOfQuestionsAnswered',
        'averageResponseLength',
        'completionRate',
      ],
    );
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: GeminiModels.gem25Flash,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: analysisSchema,
        ),
      );
      final prompt = [
        Content.text('''
You are an expert interview evaluator.

Resume Details:
${jsonEncode(_resumeController.resumeResultData.value!.toJson())}

Job Description:
${jsonEncode(_resumeController.jobAnalysisResultData.value?.toJson())}

Interview Memory (JSON):
${jsonEncode(memory.toJson())}

Conversation History:
${conversationHistory.join('\n')}

Your task:
- Analyze the candidate's interview performance holistically.
- Score clarity, depth, and structure from 0 to 100.
- Idtienfy clearconcr strengths and ete improvement areas.
- Count how many questions were answered.
- Calculate the average response length in words.
- Estimate interview completion rate:
  - 1.0 = interview fully completed
  - 0.7–0.9 = mostly completed
  - <0.7 = ended early or weak engagement

Rules:
- Be fair, objective, and constructive.
- Do NOT hallucinate experiences not present in the answers.
- Output ONLY valid JSON matching the schema.
'''),
      ];

      final response = await model.generateContent(prompt);
      final json = jsonDecode(response.text!);
      log('Interview Analysis: $json');

      interviewAnalysis.value = InterviewAnalysis.fromJson(json);
      interviewAnalysisStatus.value = RxStatus.success();
    } catch (e) {
      interviewAnalysisStatus.value = RxStatus.error(e.toString());
    }
  }

  void interviewFinshed() {
    state.value = InterviewState.finished;
    flutterTts.stop();
    speechToText.stop();
    Future.delayed(Duration(milliseconds: 300), () {
      appRouter.push(RoutesName.aiInterviewFeedback);
    });
  }
}
