import 'dart:io';

import 'package:aue/model/attendance_excuse.dart';
import 'package:aue/model/excusable_attendance.dart';
import 'package:aue/model/excuse_categories.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_dropdown.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class AttendanceExcuseRequestPage extends StatefulWidget {
  @override
  _AttendanceExcuseRequestPageState createState() => _AttendanceExcuseRequestPageState();
}

class _AttendanceExcuseRequestPageState extends State<AttendanceExcuseRequestPage> {
  Future<AttendanceExcuse> ii() {}

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Widget _buildStartEndDate() {
    return Row(
      children: [
        Expanded(
          child: _buildDate('Start Date: ', _startDateController),
        ),
        SizedBox(width: DS.width * 0.1),
        Expanded(
          child: _buildDate('End Date: ', _endDateController),
        )
      ],
    );
  }

  Widget _buildDate(String label, TextEditingController controller) {
    const InputBorder _inputBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.blueGrey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(0.0),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Stack(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: _inputBorder,
                focusedErrorBorder: _inputBorder,
                disabledBorder: _inputBorder,
                errorBorder: _inputBorder,
                contentPadding: const EdgeInsets.all(.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
                hintText: 'Select',
                hintStyle: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
              onTap: () async {
                DateTime _selectedDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        // primaryColor: AppColors.green,
                        // accentColor: const Color(0xFF8CE7F1),
                        colorScheme: ColorScheme.light(primary: AppColors.primary),
                        // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child,
                    );
                  },
                );
                controller.text = _selectedDateTime == null ? null : DateFormat('MM/dd/yyyy').format(_selectedDateTime);
                setState(() {});
              },
              readOnly: true,
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: GestureDetector(
                onTap: () async {
                  DateTime _selectedDateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          // primaryColor: AppColors.green,
                          // accentColor: const Color(0xFF8CE7F1),
                          colorScheme: ColorScheme.light(primary: AppColors.primary),
                          // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                        ),
                        child: child,
                      );
                    },
                  );
                  controller.text = _selectedDateTime == null ? null : DateFormat('MM/dd/yyyy').format(_selectedDateTime);
                  setState(() {});
                },
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Attendance Excuse Request',
      showBackButton: true,
      image: Images.classUpdates,
      isSingleChildScrollView: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStartEndDate(),
            SizedBox(height: DS.height * 0.03),
            if (_startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty)
              AttendanceExcuseWidget(
                startDate: this._startDateController.text,
                endDate: this._endDateController.text,
              ),
          ],
        ),
      ),
    );
  }
}

class AttendanceExcuseWidget extends StatefulWidget {
  final String startDate;
  final String endDate;

  AttendanceExcuseWidget({this.startDate, this.endDate});

  @override
  _AttendanceExcuseWidgetState createState() => _AttendanceExcuseWidgetState();
}

class _AttendanceExcuseWidgetState extends State<AttendanceExcuseWidget> {
  TextEditingController _excuseDetailsText = TextEditingController();

  Future<List<ExcusableAttendance>> _excusableAttendanceFuture;
  Future<List<ExcuseCategory>> _excuseCategoriesFuture;

  Widget _buildAttendanceExcuseTile(String courseName, String instructorName, String lectureHours) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black38,
      margin: const EdgeInsets.all(0.0),
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(Images.girl),
        ),
        title: Text(
          courseName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: DS.setSP(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            instructorName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.blueGrey.withOpacity(0.6),
              fontWeight: FontWeight.w300,
              fontSize: DS.setSP(14),
            ),
          ),
        ),
        trailing: Text(
          lectureHours,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildExcusableAttendance() {
    return FutureBuilder<List<ExcusableAttendance>>(
      future: _excusableAttendanceFuture,
      builder: (BuildContext context, AsyncSnapshot<List<ExcusableAttendance>> snapshot) {
        if (snapshot.isLoading) {
          return LoadingWidget();
        }
        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: snapshot.error,
            onRetryTap: () => this.getExcusableAttendance(),
          );
        }

        return Column(
          children: [
            ...snapshot.data.map((ExcusableAttendance excusableAttendance) {
              return _buildAttendanceExcuseTile(excusableAttendance.courseName, excusableAttendance.instructor, excusableAttendance.lectureHours.toString());
            })
          ],
        );
      },
    );
  }

  Widget _buildExcuseDetailsTextField() {
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
          'Excuse Details: ',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: DS.height * 0.02),
        TextFormField(
          controller: _excuseDetailsText,
          decoration: InputDecoration(
            border: _inputBorder,
            focusedErrorBorder: _inputBorder,
            disabledBorder: _inputBorder,
            errorBorder: _inputBorder,
            contentPadding: const EdgeInsets.all(7.0),
            enabledBorder: _inputBorder,
            focusedBorder: _inputBorder,
            hintText: 'Provide a description',
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

  Widget _buildExcuseCategoryDropdown() {
    return FutureBuilder<List<ExcuseCategory>>(
      future: _excuseCategoriesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<ExcuseCategory>> snapshot) {
        if (snapshot.isLoading) {
          return LoadingWidget();
        }
        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: snapshot.error,
            onRetryTap: () => this.getExcuseCategories(),
          );
        }
        return CustomDropdown<ExcuseCategory>(
          label: 'Excuse Category: ',
          textKey: 'Name',
          dataList: snapshot.data,
          onDataSelect: (ExcuseCategory excuseCategory) {},
        );
      },
    );
  }

  Widget _buildAgreeAndApplyButton() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
      margin: const EdgeInsets.all(10.0).subtract(const EdgeInsets.symmetric(horizontal: 10)),
      shadowColor: Colors.black38,
      child: InkWell(
        onTap: () async {
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Agree & Apply',
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
    );
  }

  void getExcusableAttendance() {
    _excusableAttendanceFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _excusableAttendanceFuture = Repository().getExcusableAttendance(studentId, widget.startDate, widget.endDate);
    setState(() {});
  }

  void getExcuseCategories() {
    _excuseCategoriesFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _excuseCategoriesFuture = Repository().getExcuseCategories(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getExcusableAttendance();
    this.getExcuseCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildExcusableAttendance(),
        SizedBox(height: DS.height * 0.02),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildExcuseCategoryDropdown(),
              SizedBox(height: DS.height * 0.01),
              _buildExcuseDetailsTextField(),
              SizedBox(height: DS.height * 0.03),
              ExcuseRequestAttachmentsWidget(
                onFilesSelected: (List<File> files) {},
                label: 'Supporting Document Upload',
              ),
              SizedBox(height: DS.height * 0.02),
              _buildAgreeAndApplyButton()
            ],
          ),
        ),
      ],
    );
  }
}

class ExcuseRequestAttachmentsWidget extends StatefulWidget {
  final void Function(List<File>) onFilesSelected;
  final String label;

  ExcuseRequestAttachmentsWidget({@required this.onFilesSelected, this.label});

  @override
  _ExcuseRequestAttachmentsWidgetState createState() => _ExcuseRequestAttachmentsWidgetState();
}

class _ExcuseRequestAttachmentsWidgetState extends State<ExcuseRequestAttachmentsWidget> {
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
        TextField(
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
