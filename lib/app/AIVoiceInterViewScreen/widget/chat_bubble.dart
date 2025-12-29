import 'package:flutter/material.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/controller/interview_controller.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/widget/user_avatar.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.0,
        bottom: 10,
        right: isUser ? 0 : 30,
        left: isUser ? 30 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            UserAvatar(
              avatarInitial: InterviewController().interviewerName,
              gradient: AppColors.profileGradient,
            ),
            SizedBox(width: 5),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.appBlue : AppColors.bubbleGrey,
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? Radius.circular(15) : Radius.circular(4),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: isUser ? Radius.circular(4) : Radius.circular(15),
                ),
                border: Border.all(color: AppColors.grey),
              ),
              child: Text(
                message,
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 5),
            UserAvatar(avatarInitial: 'Y', gradient: AppColors.youGradient),
          ],
        ],
      ),
    );
  }
}
