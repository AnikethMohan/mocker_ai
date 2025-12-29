import 'package:flutter/material.dart';
import 'package:mocker_ai/Common/widgets/responsive_layout.dart';
import 'package:mocker_ai/app/InterviewFeedback/view/mobile/mobile_scaffold.dart';

class InterviewFeedbackView extends StatelessWidget {
  const InterviewFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileView: InterviewFeedbackMobileScaffold(),
      desktopView: Container(
        padding: EdgeInsets.symmetric(horizontal: 400),
        child: InterviewFeedbackMobileScaffold(),
      ),
    );
  }
}
