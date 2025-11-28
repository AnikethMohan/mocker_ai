import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';
import 'package:mocker_ai/Common/GeminiModels/gemini_model_names.dart';
import 'package:mocker_ai/UploadResumePage/model/resume_upload_result.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class ResumeController extends GetxController {
  var fileName = ''.obs;
  var fileSize = ''.obs;
  var extractingResumeStatus = RxStatus.empty().obs;
  final resumeResultData = Rxn<ResumeResult?>();

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
      model: GeminiModels.gem25Flash,
    );

    // Provide a prompt that contains text
    final prompt = [
      Content.text('''
You are a resume parser. Extract the following information from the provided resume and return it as a JSON object. Ensure the output is *only* the JSON. If a field is not found, use null or an empty array as appropriate.

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
}
