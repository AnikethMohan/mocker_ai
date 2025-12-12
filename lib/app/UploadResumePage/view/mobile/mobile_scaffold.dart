import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';
import 'package:mocker_ai/app/UploadResumePage/controller/resume_controller.dart';
import 'package:mocker_ai/app/UploadResumePage/view/mobile/job_description_widget.dart';

class UploadResumeMobileScaffold extends StatefulWidget {
  const UploadResumeMobileScaffold({super.key});

  @override
  State<UploadResumeMobileScaffold> createState() =>
      _UploadResumeMobileScaffoldState();
}

class _UploadResumeMobileScaffoldState
    extends State<UploadResumeMobileScaffold> {
  bool isResumeParsingCompleted = false;
  final _sc = Get.find<ResumeController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff447DFC),
              ),
              child: Icon(CupertinoIcons.doc, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Technical interview', style: TextStyle(fontSize: 13)),
                SizedBox(height: 5),
                Text(
                  'Upload your resume for personalized questions',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_sc.fileName.value.isEmpty) ...[
                  _steps(size, 1),
                  SizedBox(height: 40),
                  Center(child: _uploadResumeContainer()),
                ] else if (!isResumeParsingCompleted) ...[
                  _steps(size, _sc.resumeResultData.value != null ? 2 : 1),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primaryBlue.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.doc,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${_sc.fileName}'),
                                    SizedBox(height: 5),
                                    Text(
                                      '${_sc.fileSize} KB',
                                      style: TextStyle(
                                        color: AppColors.subTitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              CupertinoIcons.xmark,
                              size: 20,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        if (_sc.extractingResumeStatus.value.isLoading) ...[
                          _loadingExtractingResume(),
                        ] else ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _sc.extractingResumeStatus.value.isSuccess
                                  ? AppColors.sucessSnakColor.withValues(
                                      alpha: 0.1,
                                    )
                                  : Colors.red[100],
                              border: Border.all(
                                color: AppColors.mintGreen.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_sc
                                    .extractingResumeStatus
                                    .value
                                    .isSuccess) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: AppColors.sucessSnakColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Resume processed successfully',
                                        style: TextStyle(
                                          color: AppColors.sucessSnakColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'We\'ve extracted key information to personalize your interview questions',
                                    style: TextStyle(
                                      color: AppColors.sucessSnakColor,
                                    ),
                                  ),
                                ] else
                                  Text(
                                    _sc
                                            .extractingResumeStatus
                                            .value
                                            .errorMessage ??
                                        '',
                                    style: TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 12,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: AppColors.primaryBlue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Skills Identified',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      if (_sc
                                              .resumeResultData
                                              .value
                                              ?.skills
                                              ?.isNotEmpty ??
                                          false) ...[
                                        ..._sc.resumeResultData.value!.skills!
                                            .map((e) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: AppColors.primaryBlue
                                                      .withValues(alpha: 0.2),
                                                ),
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlue,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: AppColors.primaryBlue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Experience Highlights',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (_sc
                                        .resumeResultData
                                        .value
                                        ?.experience
                                        ?.isNotEmpty ??
                                    false) ...[
                                  ..._sc.resumeResultData.value!.experience!
                                      .map((e) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .check_mark_circled,
                                                color:
                                                    AppColors.sucessSnakColor,
                                                size: 20,
                                              ),
                                              Text(
                                                e.company ?? '',
                                                style: TextStyle(
                                                  color: AppColors.primaryBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                                SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: AppColors.primaryBlue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Education background',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (_sc
                                        .resumeResultData
                                        .value
                                        ?.education
                                        ?.isNotEmpty ??
                                    false) ...[
                                  ..._sc.resumeResultData.value!.education!.map(
                                    (e) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 5,
                                          children: [
                                            Icon(
                                              CupertinoIcons.check_mark_circled,
                                              color: AppColors.sucessSnakColor,
                                              size: 20,
                                            ),
                                            Expanded(
                                              child: Text(
                                                e.degree ?? '',
                                                style: TextStyle(
                                                  color: AppColors.primaryBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_sc.resumeResultData.value != null) ...[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.grey),
                            ),
                            child: Text('Upload Different Resume'),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              isResumeParsingCompleted = true;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.grey),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    'Enter job description',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    CupertinoIcons.check_mark_circled,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ] else if (isResumeParsingCompleted) ...[
                  _steps(size, _sc.resumeResultData.value != null ? 3 : 1),
                  SizedBox(height: 50),
                  JobDescriptionWidget(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingExtractingResume() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryBlue,
            constraints: BoxConstraints(
              minWidth: 20,
              maxWidth: 20,
              maxHeight: 20,
              minHeight: 20,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Processing your resume...'),
              Text(
                'Analyzing skills,experience, and education',
                style: TextStyle(color: AppColors.primaryBlue, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _uploadResumeContainer() {
    final sc = Get.find<ResumeController>();
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: AppColors.grey,
        radius: Radius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Color(0xffe1e7fd),
                radius: 50,
                child: Icon(
                  Icons.file_upload_outlined,
                  size: 50,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text('Upload Your Resume'),
            SizedBox(height: 10),
            Text(
              'Upload your resume and our AI will analyze your experience, skills, and background to ask relevant interview questions',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () async {
                await sc.uploadAndAnalyzeResume();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_upload_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Choose File', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Supported formats: PDF, DOCX, TXT (Max 5MB)',
              style: TextStyle(fontSize: 10, color: AppColors.subTitleColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _steps(Size size, int step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.primaryBlue,
              child: step == 1
                  ? Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    )
                  : Icon(Icons.check_circle_outline, color: Colors.white),
            ),
            SizedBox(width: 10),
            SizedBox(width: 80, child: Text('Upload Resume')),
            Container(
              height: 10,
              width: 10,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.grey,
              ),
            ),
            SizedBox(width: 15),
          ],
        ),

        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: step == 2
                  ? AppColors.primaryBlue
                  : AppColors.grey,
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(width: 80, child: Text('Job Description')),
            Container(
              height: 10,
              width: 10,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.grey,
              ),
            ),
            SizedBox(width: 15),
          ],
        ),

        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: step == 3
                  ? AppColors.primaryBlue
                  : AppColors.grey,
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(width: 80, child: Text('Start interview')),
          ],
        ),
      ],
    );
  }
}
