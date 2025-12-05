import 'dart:convert';
import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:mocker_ai/Common/GeminiModels/gemini_model_names.dart';
import 'package:mocker_ai/app/UploadResumePage/controller/resume_controller.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:html';

enum InterviewState {
  idle,
  initializing,
  speaking,
  listening,
  typing, // New state for web
  processing,
  finished,
}

class InterviewController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText speechToText = SpeechToText();

  final Rx<InterviewState> state = InterviewState.idle.obs;
  final RxList<String> conversationHistory = <String>[].obs;

  final ResumeController _resumeController = Get.find<ResumeController>();

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
    // TTS initialization logic
  }

  Future<void> _initStt() async {
    await speechToText.initialize();
  }

  Future<void> startInterview() async {
    state.value = InterviewState.initializing;
    final initialQuestion = await _generateInitialQuestion();
    conversationHistory.add("AI: $initialQuestion");
    await _speak(initialQuestion);
  }

  Future<String> _generateInitialQuestion() async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: GeminiModels.gem25Flash,
    );

    final prompt = [
      Content.text('''
    You are a friendly and professional interviewer. Your goal is to conduct a technical interview based on the candidate's resume and the job description.

    Start by introducing yourself and then ask the first question. The question should be based on the candidate's experience or skills mentioned in their resume, in relation to the job description.

    Resume details:
    ${jsonEncode(_resumeController.resumeResultData.value!.toJson())}

    Job Description:
    ${_resumeController.jobDescriptionController.text}
    '''),
    ];

    final response = await model.generateContent(prompt);
    return response.text ??
        "I'm sorry, I couldn't generate a question. Could you please tell me about yourself?";
  }

  Future<void> _speak(String text) async {
    state.value = InterviewState.speaking;
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      window.navigator.getUserMedia(audio: true).then((value) {
        log('$value');
      });
      _listen();
      // if (kIsWeb) {
      //   state.value = InterviewState.typing;
      // } else {
      //   _listen();
      // }
    });
  }

  void _listen() {
    state.value = InterviewState.listening;
    speechToText.listen(
      onResult: (result) {
        log('${result.recognizedWords}');
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
    final nextQuestion = await _generateNextQuestion();
    conversationHistory.add("AI: $nextQuestion");
    await _speak(nextQuestion);
  }

  Future<String> _generateNextQuestion() async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: GeminiModels.gem25Flash,
    );

    final prompt = [
      Content.text('''
    You are a friendly and professional interviewer. Here is the conversation history so far:
    ${conversationHistory.join('\n')}

    Based on the conversation, ask the next logical and relevant question. Keep the conversation flowing naturally.
    '''),
    ];

    final response = await model.generateContent(prompt);
    return response.text ?? "That's interesting. Can you tell me more?";
  }

  void endInterview() {
    state.value = InterviewState.finished;
    flutterTts.stop();
    speechToText.stop();
    if (!kIsWeb) {
      speechToText.stop();
    }
  }
}
