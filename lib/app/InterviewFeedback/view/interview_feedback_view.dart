import 'package:flutter/material.dart';
import 'package:mocker_ai/Common/widgets/responsive_layout.dart';

class InterviewFeedbackView extends StatelessWidget {
  const InterviewFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobileView: Container(), desktopView: Container());
  }
}
