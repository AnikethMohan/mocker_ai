import 'package:flutter/material.dart';
import 'package:mocker_ai/Common/widgets/responsive_layout.dart';
import 'package:mocker_ai/app/UploadResumePage/view/mobile/mobile_scaffold.dart';

class UploadResumeView extends StatelessWidget {
  const UploadResumeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileView: UploadResumeMobileScaffold(),
      desktopView: UploadResumeMobileScaffold(),
    );
  }
}
