import 'dart:io';

import 'package:aue/pages/tabs_view/courses/widgets/course_withdrawal_attachments_widget.dart';
import 'package:aue/res/res.dart';
import 'package:flutter/material.dart';

class RequestIncompleteExam extends StatefulWidget {

  @override
  _RequestIncompleteExamState createState() => _RequestIncompleteExamState();
}

class _RequestIncompleteExamState extends State<RequestIncompleteExam> {

  TextEditingController _reasonText = TextEditingController();
  List<File> _selectedFiles;

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
      body: Column(
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
            padding: const EdgeInsets.all(16.0)
                .subtract(const EdgeInsets.only(bottom: 16.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: AppColors.primary),
                Text(
                  "Incomplete Exam",
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
                _buildReasonTextField(),
                SizedBox(height: DS.height * 0.02),
                CourseWithdrawalAttachmentsWidget(
                  label: 'Supporting Document: ',
                  onFilesSelected: (List<File> files) {
                    _selectedFiles = files;
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
            child: Card(
              color: Colors.white,
              elevation: 6.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
              margin: const EdgeInsets.all(0.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Apply Now',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
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
          )
        ],
      ),
    );
  }
}
