import 'dart:io';

import 'package:aue/res/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;

class CourseWithdrawalAttachmentsWidget extends StatefulWidget {

  final void Function(List<File>) onFilesSelected;
  final String label;

  CourseWithdrawalAttachmentsWidget({@required this.onFilesSelected, this.label});

  @override
  _CourseWithdrawalAttachmentsWidgetState createState() => _CourseWithdrawalAttachmentsWidgetState();
}

class _CourseWithdrawalAttachmentsWidgetState extends State<CourseWithdrawalAttachmentsWidget> {
  TextEditingController _filesSelectedText = TextEditingController();
  List<File> _selectedFiles;

  Future<void> _onFilePick() async {
    _selectedFiles = await FilePicker.getMultiFile(
      type: FileType.any,
    );
    List<String> filesNames = _selectedFiles.map((File file) => path.basename(file.path)).toList();
    _filesSelectedText.text = filesNames.join(', ');
    widget.onFilesSelected(_selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    const InputBorder _inputBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.blueGrey,
        width: 1.3,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? 'Attachments: (if any)',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        TextFormField(
          controller: _filesSelectedText,
          readOnly: true,
          onTap: () async {
            await _onFilePick();
          },
          style: const TextStyle(
            color: AppColors.blueGrey,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          validator: (String value) {
            if (value.isEmpty || value == null) {
              return 'Select document';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'No file selected',
            hintStyle: const TextStyle(
              color: AppColors.blueGrey,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
            border: _inputBorder,
            focusedBorder: _inputBorder,
            enabledBorder: _inputBorder,
            errorBorder: _inputBorder,
            disabledBorder: _inputBorder,
            focusedErrorBorder: _inputBorder,
            suffixIcon: const Icon(
              Icons.folder_open,
              color: AppColors.blueGrey,
            ),
            suffixIconConstraints: BoxConstraints.tight(const Size.square(23)),
          ),
        ),
      ],
    );
  }
}
