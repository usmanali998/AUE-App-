import 'dart:io';

import 'package:aue/model/apply_course_withdrawal.dart';
import 'package:aue/model/course_withdrawal_reason.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/courses/widgets/course_withdrawal_attachments_widget.dart';
import 'package:aue/pages/tabs_view/courses/widgets/course_withdrawal_data_widget.dart';
import 'package:aue/pages/tabs_view/courses/widgets/course_withdrawal_reasons_widget.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class CourseWithdrawalPage extends StatefulWidget {
  @override
  _CourseWithdrawalPageState createState() => _CourseWithdrawalPageState();
}

class _CourseWithdrawalPageState extends State<CourseWithdrawalPage> {
  TextEditingController _reasonText = TextEditingController();
  List<File> _selectedFiles;
  CourseWithdrawalReason _selectedReason;
  String _grade;
  double _refundPercentage;
  bool _isLoading = false;

  Widget _buildReasonTextField() {
    const InputBorder _inputBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.blueGrey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(0.0),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reason',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: DS.height * 0.02),
        TextField(
          controller: _reasonText,
          decoration: InputDecoration(
            border: _inputBorder,
            focusedErrorBorder: _inputBorder,
            disabledBorder: _inputBorder,
            errorBorder: _inputBorder,
            contentPadding: const EdgeInsets.all(7.0),
            enabledBorder: _inputBorder,
            focusedBorder: _inputBorder,
            hintText: 'Please write any specific reason over here....',
            hintStyle: const TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
            ),
          ),
          style: const TextStyle(
            color: AppColors.blueGrey,
            fontWeight: FontWeight.w700,
            fontSize: 14.0,
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 44.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0).subtract(const EdgeInsets.only(bottom: 16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: AppColors.primary),
                  Text(
                    "Course Withdrawal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(20),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: ImageIcon(
                      const AssetImage(Images.bell),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CourseWithdrawalDataWidget(
                    data: (String grade, double refundPercentage) {
                      _grade = grade;
                      _refundPercentage = refundPercentage;
                    },
                  ),
                  SizedBox(height: DS.height * 0.02),
                  CourseWithdrawalReasonsWidget(
                    onReasonSelect: (CourseWithdrawalReason reason) {
                      _selectedReason = reason;
                    },
                  ),
                  _buildReasonTextField(),
                  SizedBox(height: DS.height * 0.02),
                  CourseWithdrawalAttachmentsWidget(
                    onFilesSelected: (List<File> files) {
                      _selectedFiles = files;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: _isLoading
                        ? Center(child: const CircularProgressIndicator())
                        : InkWell(
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_selectedReason == null) {
                                await Get.defaultDialog(
                                  title: 'Warning',
                                  content: const Text('Reason category must be selected.'),
                                  confirm: FlatButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                return;
                              }
                              ApplyCourseWithdrawal applyCourseWithdrawalModel = ApplyCourseWithdrawal();
                              applyCourseWithdrawalModel?.studentId = context.read<AuthNotifier>()?.user?.studentID;
                              applyCourseWithdrawalModel?.sectionId = context.read<AppStateNotifier>()?.selectedSection?.sectionId;
                              applyCourseWithdrawalModel?.reasonId = _selectedReason?.id;
                              applyCourseWithdrawalModel?.reasonText = _selectedReason?.reasonTypeEn;
                              applyCourseWithdrawalModel?.grade = _grade ?? null;
                              applyCourseWithdrawalModel?.refundPercentage = _refundPercentage ?? null;
                              applyCourseWithdrawalModel?.attachments = _selectedFiles?.map<Map<String, dynamic>>((File file) {
                                return {'StringValue': path.basename(file.path), 'ByteValues': file.readAsBytesSync()};
                              })?.toList();
                              var isRequestSubmit = await Repository().submitWithdrawalRequest(applyCourseWithdrawalModel);
                              await Get.defaultDialog(
                                title: 'Withdrawal Request',
                                content: Text(isRequestSubmit),
                                confirm: FlatButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 4.0,
                              shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                              margin: const EdgeInsets.all(0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Submit Withdrawal Request',
                                      style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(
                                          const BorderSide(color: AppColors.primary, width: 1.5),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
