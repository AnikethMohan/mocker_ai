import 'package:get/instance_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/controller/interview_controller.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/view/ai_voice_interview_view.dart';
import 'package:mocker_ai/app/UploadResumePage/controller/resume_controller.dart';
import 'package:mocker_ai/app/UploadResumePage/view/upload_resume_view.dart';
import 'package:mocker_ai/routes/routes_name.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RoutesName.home,
      builder: (context, state) {
        Get.lazyPut(() => ResumeController());
        return const UploadResumeView();
      },
    ),
    GoRoute(
      path: RoutesName.aiVoiceInterview,
      builder: (context, state) {
        Get.lazyPut(() => InterviewController());
        return const AIVoiceInterViewScreen();
      },
    ),
  ],
);
