import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';
import 'package:mocker_ai/Common/widgets/responsive_layout.dart';

class InterviewFeedbackMobileScaffold extends StatelessWidget {
  const InterviewFeedbackMobileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      '88',
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
            value: 93,
            icon: Icons.chat_bubble_outline,
          ),
          SizedBox(height: 20),
          InterviewStatCard(
            title: 'Depth',
            color: Color(0xffA14DFD),
            value: 94,
            icon: Icons.trending_up_rounded,
          ),
          SizedBox(height: 20),
          InterviewStatCard(
            title: 'Structure',
            color: Color(0xff4FC65F),
            value: 90,
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
                        color: AppColors.sucessSnakColor.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        CupertinoIcons.check_mark_circled,
                        color: AppColors.sucessSnakColor,
                      ),
                    ),
                    Text('Structure', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
