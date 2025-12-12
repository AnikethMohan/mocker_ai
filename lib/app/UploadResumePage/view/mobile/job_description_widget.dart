import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';
import 'package:mocker_ai/app/UploadResumePage/controller/resume_controller.dart';
import 'package:mocker_ai/routes/routes_name.dart';

class JobDescriptionWidget extends StatefulWidget {
  const JobDescriptionWidget({super.key});

  @override
  State<JobDescriptionWidget> createState() => _JobDescriptionWidgetState();
}

class _JobDescriptionWidgetState extends State<JobDescriptionWidget> {
  final _sc = Get.find<ResumeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Obx(
          () => Column(
            spacing: 15,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Paste job description'),
                    Text(
                      'Copy and paste the full job posting to get interview questions tailored to the role',
                      style: TextStyle(fontSize: 10, color: AppColors.grey),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _sc.jobDescriptionController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              'Paste the job description here...\n\nInclude:\n- Job title \n- Responsibilities \n- Required skills \n- Qualifications \n- Company information',
                          hintStyle: TextStyle(color: AppColors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 3,
                      children: [
                        Text(
                          '${_sc.jobDescriptionController.text.length} charcters . ${_sc.jobDescriptionController.text.split(' ').where((element) => element.isNotEmpty).length} words',
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (_sc.jobAnalysisStatus.value !=
                                    RxStatus.loading()) {
                                  _sc.analyzeResumeWithJobDescription();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  spacing: 5,
                                  children:
                                      _sc.jobAnalysisStatus.value.isLoading
                                      ? [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1,
                                            ),
                                          ),
                                          Text(
                                            'Analyzing',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ]
                                      : [
                                          Icon(
                                            CupertinoIcons.sparkles,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            ' Analyze Job Description',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_sc.jobAnalysisStatus.value.isSuccess) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            CupertinoIcons.sparkles,
                            color: AppColors.primaryBlue,
                          ),
                          Text(
                            'AI Analysis complete',
                            style: TextStyle(color: AppColors.primaryBlue),
                          ),
                        ],
                      ),

                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 20,
                            color: AppColors.grey,
                          ),
                          Text('Target Role'),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          _sc.jobAnalysisResultData.value?.targetRole ?? '',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Resume Match Score'),
                          SizedBox(height: 5),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  minHeight: 7,
                                  borderRadius: BorderRadius.circular(100),
                                  value:
                                      (_sc
                                              .jobAnalysisResultData
                                              .value
                                              ?.resumeMatchScore ??
                                          0) /
                                      100,
                                  color: checkColor(
                                    (_sc
                                            .jobAnalysisResultData
                                            .value
                                            ?.resumeMatchScore ??
                                        0),
                                  ),
                                ),
                              ),
                              Text(
                                '${(_sc.jobAnalysisResultData.value?.resumeMatchScore ?? 0)}%',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('Tip: ${_sc.jobAnalysisResultData.value?.tip}'),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          GoRouter.of(
                            context,
                          ).push(RoutesName.aiVoiceInterview);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Start Interview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        _resumeInfo(),

        _protips(),
      ],
    );
  }

  Container _resumeInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Resume'),
          SizedBox(height: 10),
          Text('File', style: TextStyle(fontSize: 12)),
          Text(_sc.fileName.value, style: TextStyle(fontSize: 10)),
          SizedBox(height: 10),
          Text('Top skills', style: TextStyle(fontSize: 12)),
          SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              if (_sc.resumeResultData.value?.skills?.isNotEmpty ?? false)
                ..._sc.resumeResultData.value!.skills!.map((e) {
                  return Chip(
                    color: WidgetStatePropertyAll(Colors.white),
                    padding: EdgeInsets.all(0),
                    label: Text(e, style: TextStyle(fontSize: 8)),
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }

  Container _protips() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.sparkles, color: AppColors.primaryBlue),
              SizedBox(width: 10),
              Text('Pro Tips', style: TextStyle(color: AppColors.primaryBlue)),
            ],
          ),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.circle, size: 5),
              Text(
                'Include the full job posting for best results',
                style: TextStyle(color: AppColors.primaryBlue),
              ),
            ],
          ),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.circle, size: 5),
              Text(
                'The AI will match required skills with your resume',
                style: TextStyle(color: AppColors.primaryBlue),
              ),
            ],
          ),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.circle, size: 5),
              Text(
                'Questions will focus on role-specific scenarios',
                style: TextStyle(color: AppColors.primaryBlue),
              ),
            ],
          ),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.circle, size: 5),
              Text(
                'You can skip this step and use your resume onlyd',
                style: TextStyle(color: AppColors.primaryBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color checkColor(double value) {
  if (value >= 75) {
    return AppColors.sucessSnakColor;
  } else if (value <= 50 && value > 40) {
    return Colors.orange[400]!;
  }
  return Colors.redAccent;
}
