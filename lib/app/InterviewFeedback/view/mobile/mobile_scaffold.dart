import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';
import 'package:mocker_ai/Common/widgets/responsive_layout.dart';
import 'package:mocker_ai/app/AIVoiceInterViewScreen/controller/interview_controller.dart';

class InterviewFeedbackMobileScaffold extends StatefulWidget {
  const InterviewFeedbackMobileScaffold({super.key});

  @override
  State<InterviewFeedbackMobileScaffold> createState() =>
      _InterviewFeedbackMobileScaffoldState();
}

class _InterviewFeedbackMobileScaffoldState
    extends State<InterviewFeedbackMobileScaffold> {
  final _sc = Get.find<InterviewController>();

  @override
  void initState() {
    _sc.analyzeInterview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_sc.interviewAnalysisStatus.value.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (_sc.interviewAnalysisStatus.value.isSuccess) {
          final interviewAnalysis = _sc.interviewAnalysis.value;
          return ListView(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
            children: [
              _congratulationCard(),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff6D54F6),
                            Color(0xff7250F6),
                            Color(0xff764Bf5),
                            Color(0xff7A45F4),
                            Color(0xff7F3Ff4),
                            Color(0xff813AF3),
                            Color(0xff8337F3),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          interviewAnalysis.overAllPerformance.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Overall Performance'),

                    Text('Great work!'),
                  ],
                ),
              ),
              SizedBox(height: 25),
              InterviewStatCard(
                title: 'Clarity',
                color: Color(0xff447DFC),
                value: interviewAnalysis.clarity ?? 0,
                icon: Icons.chat_bubble_outline,
              ),
              SizedBox(height: 20),
              InterviewStatCard(
                title: 'Depth',
                color: Color(0xffA14DFD),
                value: interviewAnalysis.depth ?? 0,
                icon: Icons.trending_up_rounded,
              ),
              SizedBox(height: 20),
              InterviewStatCard(
                title: 'Structure',
                color: Color(0xff4FC65F),
                value: interviewAnalysis.structure ?? 0,
                icon: Icons.star_outline_rounded,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Column(
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.sucessSnakColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.check_mark_circled,
                            color: AppColors.sucessSnakColor,
                          ),
                        ),
                        Text('Key Strengths', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (interviewAnalysis.keyStrengths?.isNotEmpty ??
                        false) ...[
                      ...interviewAnalysis.keyStrengths!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Icon(
                                CupertinoIcons.check_mark_circled,
                                color: AppColors.sucessSnakColor,
                              ),
                              SizedBox(
                                width: screenWidth * 0.85,
                                child: Text(e, style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.brown.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.trending_up_rounded,
                            color: AppColors.brown,
                          ),
                        ),
                        Text(
                          'Areas to imporve',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (interviewAnalysis.areasToImprove?.isNotEmpty ??
                        false) ...[
                      ...interviewAnalysis.areasToImprove!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                color: AppColors.brown,
                              ),
                              SizedBox(
                                width: screenWidth * 0.85,
                                child: Text(e, style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Interview statistics'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        interviewStatCol(
                          interviewAnalysis.numberOfQuestionsAnswered
                              .toString(),
                          'Questions Answered',
                        ),
                        interviewStatCol(
                          interviewAnalysis.averageResponseLength.toString(),
                          'Avg. Response Length',
                        ),
                        interviewStatCol(
                          interviewAnalysis.completionRate.toString(),
                          'Completion Rate',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Center(
          child: Text(_sc.interviewAnalysisStatus.value.errorMessage ?? ''),
        );
      }),
    );
  }

  Column interviewStatCol(String statValue, String statName) {
    return Column(
      children: [
        Text(
          statValue,
          style: TextStyle(color: AppColors.primaryBlue, fontSize: 20),
        ),
        SizedBox(height: 5),
        Text(statName),
      ],
    );
  }

  Container _congratulationCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.checkGreen.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.checkGreen),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.checkGreen,
            child: Icon(CupertinoIcons.check_mark_circled, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interview Complete! 🎉',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: screenWidth * 0.6,
                child: Text(
                  'Great job completing your  interview! Here\'s your performance summary and personalized feedback.',
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InterviewStatCard extends StatelessWidget {
  const InterviewStatCard({
    super.key,
    this.value = 0,
    required this.title,
    this.color = AppColors.disabledBlue,
    required this.icon,
  });
  final double value;
  final String title;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withValues(alpha: 0.2),
                ),
                child: Icon(icon, color: color),
              ),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: '$value',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: ' /100',
                  style: TextStyle(fontSize: 18, color: AppColors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: value / 100,
            borderRadius: BorderRadius.circular(20),
            minHeight: 6,
            color: color,
          ),
        ],
      ),
    );
  }
}
