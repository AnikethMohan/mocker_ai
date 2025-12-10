import 'package:flutter/material.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';

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
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: AppColors.grey),
              ),
              child: Text(
                message,
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
