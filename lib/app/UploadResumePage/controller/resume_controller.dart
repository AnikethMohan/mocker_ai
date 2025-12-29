import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mocker_ai/Common/GeminiModels/gemini_model_names.dart';
import 'package:mocker_ai/app/UploadResumePage/model/job_analysis_data.dart';
import 'package:mocker_ai/app/UploadResumePage/model/resume_upload_result.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class ResumeController extends GetxController {
  var fileName = ''.obs;
  var fileSize = ''.obs;
  var extractingResumeStatus = RxStatus.empty().obs;
  final resumeResultData = Rxn<ResumeResult?>();
  final jobDescriptionController = TextEditingController();

  var jobAnalysisStatus = RxStatus.empty().obs;
  final jobAnalysisResultData = Rxn<JobAnalysisResult?>();

  Future<ResumeResult?> uploadAndAnalyzeResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      fileName.value = result.files.single.name;
      final bytes = result.files.single.bytes;
      // bytes can be null if only a path was returned; compute size safely
      fileSize.value = ((bytes?.length ?? 0) / 1024).toStringAsFixed(2);
      if (bytes == null) {
        return null;
      }
      try {
        extractingResumeStatus.value = RxStatus.loading();
        final resumeText = await _extractTextFromPdf(bytes);
        final cleaned = resumeText
            .replaceAll('```json', ' ')
            .replaceAll('```', ' ');
        final json = jsonDecode(cleaned);
        log(cleaned);
        resumeResultData.value = ResumeResult.fromJson(json);
        extractingResumeStatus.value = RxStatus.success();
        return resumeResultData.value;
      } catch (e) {
        extractingResumeStatus.value = RxStatus.error(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String> _extractTextFromPdf(List<int> bytes) async {
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final String text = PdfTextExtractor(document).extractText();
    final usable = await _getUsableJsonFromText(text);

    document.dispose();
    return usable;
  }

  Future<String> _getUsableJsonFromText(String resume) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: GeminiModels.gem25Lite,
    );

    // Provide a prompt that contains text
    final prompt = [
      Content.text('''
              You are a resume parser. Extract the following information from the provided resume and return it as a JSON object. Ensure the output is *only* the JSON.Try not to repeat any experience or data . If a field is not found, use null or an empty array as appropriate.

              JSON Schema:
              ```json
              {
                "name": "string",
                "contactInfo": {
                  "email": "string",
                  "phone": "string",
                  "linkedin": "string"
                },
                "experience": [
                  {
                    "title": "string",
                    "company": "string",
                    "startDate": "string",
                    "endDate": "string",
                    "description": "string"
                  }
                ],
                "education": [
                  {
                    "degree": "string",
                    "university": "string",
                    "graduationYear": "number"
                  }
                ],
                "skills": ["string"]
              }
       '''),
      Content.text(resume),
    ];

    // To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);

    return response.text ?? '';
  }

  Future<void> analyzeResumeWithJobDescription() async {
    if (resumeResultData.value == null) {
      jobAnalysisStatus.value = RxStatus.error(
        "Please upload and parse a resume first.",
      );
      return;
    }
    if (jobDescriptionController.text.isEmpty) {
      jobAnalysisStatus.value = RxStatus.error(
        "Please provide a job description.",
      );
      return;
    }

    try {
      jobAnalysisStatus.value = RxStatus.loading();

      // Define the JSON schema for job analysis output
      final jobAnalysisSchema = Schema.object(
        properties: {
          'targetRole': Schema.string(),
          'requiredSkillsIdentified': Schema.array(items: Schema.string()),
          'resumeMatchScore': Schema.number(),
          'tip': Schema.string(),
        },
        optionalProperties: [
          'targetRole',
          'requiredSkillsIdentified',
          'resumeMatchScore',
          'tip',
        ],
      );

      final model = FirebaseAI.googleAI().generativeModel(
        model: GeminiModels
            .gem25Flash, // You can use a more capable model if needed
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: jobAnalysisSchema,
        ),
      );

      final prompt = [
        Content.text('''
              You are an expert HR analyst. Analyze the provided resume and job description.
              Extract the target role and key required skills from the job description.
              Then, compare the resume's skills and experience against these required skills.
              Finally, provide a resume match score as a percentage (0-100) indicating how well the resume matches the job description and also provide a tip or a small analysis .

              Ensure the output is *only* the JSON. If a field is not found, use null or an empty array as appropriate.

              Resume details (extracted JSON):
              ${jsonEncode(resumeResultData.value!.toJson())}

              Job Description:
              ${jobDescriptionController.text}
      '''),
      ];

      final response = await model.generateContent(prompt);
      final String? responseText = response.text;

      if (responseText != null && responseText.isNotEmpty) {
        final cleaned = responseText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final json = jsonDecode(cleaned);
        log("Job Analysis JSON: $cleaned");
        jobAnalysisResultData.value = JobAnalysisResult.fromJson(json);
        resumeResultData.value?.jobAnalysisResult = jobAnalysisResultData.value;
        jobAnalysisStatus.value = RxStatus.success();
      } else {
        jobAnalysisStatus.value = RxStatus.error(
          "No content generated from job analysis.",
        );
      }
    } catch (e) {
      log("Error analyzing job description: $e");
      jobAnalysisStatus.value = RxStatus.error(e.toString());
    }
  }
}
