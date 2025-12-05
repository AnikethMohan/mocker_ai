import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/controller/interview_controller.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/widget/chat_bubble.dart';

class AIVoiceInterViewScreen extends StatefulWidget {
  const AIVoiceInterViewScreen({super.key});

  @override
  State<AIVoiceInterViewScreen> createState() => _AIVoiceInterViewScreenState();
}

class _AIVoiceInterViewScreenState extends State<AIVoiceInterViewScreen> {
  final InterviewController controller = Get.put(InterviewController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDFEFF),
      appBar: AppBar(
        // title: const Text('AI Voice Interview'),
        actions: [
          Obx(() {
            if (controller.state.value == InterviewState.idle ||
                controller.state.value == InterviewState.finished) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => controller.startInterview(),
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () => controller.endInterview(),
              );
            }
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.conversationHistory.length,
                padding: EdgeInsets.only(bottom: 100),
                itemBuilder: (context, index) {
                  final message = controller.conversationHistory[index];
                  final isUser = message.startsWith("You:");
                  return ChatBubble(
                    message: isUser
                        ? message.substring(4)
                        : message.substring(3),
                    isUser: isUser,
                  );
                },
              );
            }),
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _getStatusText(controller.state.value),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
          if (kIsWeb) _buildWebInput(),
        ],
      ),
      bottomSheet: Obx(
        () => Container(
          color: Color(0xffEAEAEA),
          padding: EdgeInsets.only(top: 10),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        controller.state.value == InterviewState.speaking ||
                            controller.state.value ==
                                InterviewState.initializing
                        ? AppColors.disabledBlue
                        : AppColors.primaryBlue,
                  ),

                  child: Icon(
                    CupertinoIcons.mic,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
              controller.state.value == InterviewState.speaking
                  ? Column(
                      children: [
                        Text(
                          'Interviewer is speaking...',
                          style: TextStyle(color: AppColors.primaryBlue),
                        ),
                        Text('Please wait', style: TextStyle(fontSize: 12)),
                      ],
                    )
                  : controller.state.value == InterviewState.idle
                  ? Text('Click the microphone to start')
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebInput() {
    return Obx(() {
      if (controller.state.value == InterviewState.typing) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "Type your answer here...",
                  ),
                  onSubmitted: (text) {
                    controller.processAnswer(text);
                    _textController.clear();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  controller.processAnswer(_textController.text);
                  _textController.clear();
                },
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  String _getStatusText(InterviewState state) {
    switch (state) {
      case InterviewState.idle:
        return "Press play to start the interview.";
      case InterviewState.initializing:
        return "Initializing...";
      case InterviewState.speaking:
        return "AI is speaking...";
      case InterviewState.listening:
        return "Listening...";
      case InterviewState.typing:
        return "Type your answer below.";
      case InterviewState.processing:
        return "Processing...";
      case InterviewState.finished:
        return "Interview finished.";
    }
  }
}
