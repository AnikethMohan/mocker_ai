import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:mocker_ai/UploadResumePage/controller/resume_controller.dart';
import 'package:mocker_ai/UploadResumePage/view/upload_resume_view.dart';
import 'package:mocker_ai/routes/routes_name.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RoutesName.home,
      builder: (context, state) {
        Get.lazyPut(() => ResumeController());
        return UploadResumeView();
      },
    ),
  ],
);
