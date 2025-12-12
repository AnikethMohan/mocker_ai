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
  void initState() {
    controller.startInterview();
    super.initState();
  }

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
                onPressed: () => controller.interviewFinshed(),
              );
            }
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: controller.conversationHistory.length,
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    final message = controller.conversationHistory[index];
                    final isUser = message.startsWith("You:");
                    return Column(
                      children: [
                        ChatBubble(
                          message: isUser
                              ? message.substring(4)
                              : message.substring(3),
                          isUser: isUser,
                        ),
                        if (index ==
                                controller.conversationHistory.length - 1 &&
                            controller.state.value ==
                                InterviewState.processing) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: AppColors.grey),
                              ),
                              child: Row(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    'Ai is thinking',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
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
                onPressed: () {
                  if (controller.state.value ==
                      InterviewState.finshedSpeaking) {
                    controller.listen();
                  } else {
                    controller.speechToText.stop();
                  }
                },
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
                  : controller.state.value == InterviewState.finshedSpeaking
                  ? Text('Click the microphone to speak')
                  : controller.state.value == InterviewState.listening
                  ? Text('Click the button after you have finished speaking')
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
      case InterviewState.finshedSpeaking:
        return 'Click microphone to speak';
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
