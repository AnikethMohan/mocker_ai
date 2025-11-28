import 'package:flutter/widgets.dart';
import 'package:mocker_ai/Common/widgets/desktop_scaffold.dart';
import 'package:mocker_ai/UploadResumePage/view/mobile/mobile_scaffold.dart';

class UploadResumeDesktopScaffold extends StatelessWidget {
  const UploadResumeDesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(child: UploadResumeMobileScaffold());
  }
}
