import 'dart:convert';
import 'dart:io';

import 'package:aue/model/apply_academic_grievance.dart';
import 'package:aue/model/grievance_academic_form.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/notifiers/base_notifier.dart';
import 'package:aue/pages/tabs_view/courses/widgets/course_withdrawal_attachments_widget.dart';
import 'package:aue/pages/tabs_view/services/grievance/grievance_page.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_dropdown.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/loadingWidget.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AcademicGrievancePage extends StatefulWidget {
  final String title;
  final String content;

  AcademicGrievancePage({
    @required this.title,
    @required this.content,
  });

  @override
  _AcademicGrievancePageState createState() => _AcademicGrievancePageState();
}

class _AcademicGrievancePageState extends State<AcademicGrievancePage> {
  Future<GrievanceAcademicForm> _grievanceAcademicFormFuture;

  TextEditingController _grievanceDetailsController;

  GrievanceAcademicCategory _selectedCategory;
  GrievanceAcademicCourse _selectedCourse;
  GrievanceAcademicCourseMark _selectedCourseMark;
  List<CommunicatedTo> _communicatedToList;
  List<File> _selectedFiles;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void getGrievanceAcademicForm() {
    _grievanceAcademicFormFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _grievanceAcademicFormFuture =
        Repository().getGrievanceAcademicForm(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getGrievanceAcademicForm();
  }

  void _onSaveGrievance(AppStateNotifier model) async {
    if (!_formKey.currentState.validate()) {
      print('InValidate');
      return;
    }
    model.setViewState(ViewState.Busy);
    ApplyAcademicGrievance applyAcademicGrievance = ApplyAcademicGrievance()
      ..studentId = context.read<AuthNotifier>().user.studentID
      ..categoryId = _selectedCategory?.id ?? 0
      ..courseId = _selectedCourse?.courseId ?? 0
      ..courseWorkId = _selectedCourseMark?.courseWorkId ?? 0
      ..details = _grievanceDetailsController?.text ?? ""
      ..communicatedTo = _communicatedToList
      ..attachments = _selectedFiles.map((File file) {
        return base64Encode(file.readAsBytesSync());
      }).toList();

    try {
      String result = await Repository().applyAcademicGrievance(
          applyAcademicGrievance, (int count, int total) {
        if (count == total) {
          model.setViewState(ViewState.Idle);
          // Get.off(GrievancePage());
        }
      });
      Get.back();
      Get.off(GrievancePage());
      Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
      Get.back();
      model.setViewState(ViewState.Idle);
    }
  }

  Widget _buildCard(String title, String description) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
        margin: const EdgeInsets.all(0.0),
        shadowColor: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.all(12.0)
              .add(const EdgeInsets.symmetric(horizontal: 6.0)),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.blackGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: DS.height * 0.015),
              Text(
                description,
                style: const TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    height: 1.4),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }

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
          'Grievance Details',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: DS.height * 0.02),
        TextField(
          controller: _grievanceDetailsController,
          decoration: InputDecoration(
            border: _inputBorder,
            focusedErrorBorder: _inputBorder,
            disabledBorder: _inputBorder,
            errorBorder: _inputBorder,
            contentPadding: const EdgeInsets.all(7.0),
            enabledBorder: _inputBorder,
            focusedBorder: _inputBorder,
            hintText:
                'Please provide a description of your grievance in detail (*)',
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
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.all(16.0)
                    .subtract(const EdgeInsets.only(bottom: 16.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(color: AppColors.primary),
                    const Spacer(),
                    Text(
                      "New Grievance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: DS.setSP(20),
                      ),
                    ),
                    const Spacer(flex: 2),
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
                padding: EdgeInsets.symmetric(
                    horizontal: DS.width * 0.05, vertical: DS.height * 0.01),
                child: _buildCard(widget.title, widget.content),
              ),
              FutureBuilder<GrievanceAcademicForm>(
                future: _grievanceAcademicFormFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<GrievanceAcademicForm> snapshot) {
                  if (snapshot.isLoading) {
                    return LoadingWidget();
                  }
                  if (snapshot.hasError && snapshot.error != null) {
                    return CustomErrorWidget(
                      err: snapshot.error,
                      onRetryTap: () => this.getGrievanceAcademicForm(),
                    );
                  }
                  print(snapshot.data.toJson());
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DS.width * 0.07, vertical: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown<GrievanceAcademicCategory>(
                          label: 'Grievance Category',
                          dataList: snapshot.data.category,
                          textKey: 'Name',
                          onDataSelect: (GrievanceAcademicCategory
                              selectedGrievanceCategory) {
                            print(selectedGrievanceCategory);
                            _selectedCategory = selectedGrievanceCategory;
                            setState(() {});
                          },
                        ),
                        Transform.translate(
                          offset: const Offset(0, -12),
                          child: Text(
                            this._selectedCategory?.description ?? '',
                            style: const TextStyle(
                                color: AppColors.blueGrey,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(height: DS.height * 0.01),
                        CustomDropdown<GrievanceAcademicCourse>(
                          label: 'Course',
                          dataList: snapshot.data.courses,
                          textKey: 'CourseName',
                          onDataSelect: (GrievanceAcademicCourse
                              selectedGrievanceCourse) {
                            print(selectedGrievanceCourse);
                            _selectedCourse = selectedGrievanceCourse;
                            setState(() {});
                          },
                        ),
                        // CustomDropdown<String>(
                        //   label: 'Course',
                        //   dataList: _courses,
                        //   onDataSelect: (String selectedCourse) {
                        //     print(selectedCourse);
                        //   },
                        // ),
                        CustomDropdown<GrievanceAcademicCourseMark>(
                          label: 'Coursework/Assessment (*)',
                          dataList: snapshot.data.courseMarks,
                          textKey: 'Name',
                          onDataSelect:
                              (GrievanceAcademicCourseMark selectedCourseMark) {
                            print(selectedCourseMark);
                            _selectedCourseMark = selectedCourseMark;
                          },
                        ),
                        GrievanceCommunicatedBefore(
                          selectedCourse: _selectedCourse ?? null,
                          grievanceAcademicAcademicAdvisor:
                              snapshot.data?.academicAdvisor?.first,
                          communicatedToList:
                              (List<CommunicatedTo> communicatedToLst) {
                            _communicatedToList = communicatedToLst;
                          },
                        ),
                        _buildReasonTextField(),
                        SizedBox(height: DS.height * 0.02),
                        CourseWithdrawalAttachmentsWidget(
                          onFilesSelected: (List<File> files) {
                            _selectedFiles = files;
                          },
                          label: 'Supporting Evidence (optional)',
                        ),
                        SizedBox(height: DS.height * 0.02),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 4.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(12.0),
                              ),
                            ),
                            margin: const EdgeInsets.all(0.0),
                            shadowColor: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0).add(
                                  const EdgeInsets.symmetric(horizontal: 6.0)),
                              child: Text(
                                'I hereby declare that all information provided in this grievance form is true and accurate to the best of my knowledge.',
                                style: const TextStyle(
                                    color: AppColors.blueGrey,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        Consumer<AppStateNotifier>(
                          builder: (BuildContext context,
                              AppStateNotifier model, _) {
                            return model.viewState == ViewState.Busy
                                ? const CircularProgressIndicator()
                                : Card(
                                    color: Colors.white,
                                    elevation: 4.0,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(12.0))),
                                    margin: const EdgeInsets.all(10.0).add(
                                        const EdgeInsets.symmetric(
                                            vertical: 10.0)),
                                    shadowColor: Colors.black38,
                                    child: InkWell(
                                      onTap: () => _onSaveGrievance(model),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Agree & Save Grievance',
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
                                                  const BorderSide(
                                                      color: AppColors.primary,
                                                      width: 1.5),
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
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GrievanceCommunicatedBefore extends StatefulWidget {
  final GrievanceAcademicCourse selectedCourse;
  final GrievanceAcademicAcademicAdvisor grievanceAcademicAcademicAdvisor;
  final void Function(bool, bool, bool) communicatedData;
  final void Function(List<CommunicatedTo> communicatedToList)
      communicatedToList;

  GrievanceCommunicatedBefore(
      {this.communicatedData,
      this.selectedCourse,
      this.grievanceAcademicAcademicAdvisor,
      this.communicatedToList});

  @override
  _GrievanceCommunicatedBeforeState createState() =>
      _GrievanceCommunicatedBeforeState();
}

class _GrievanceCommunicatedBeforeState
    extends State<GrievanceCommunicatedBefore> {
  bool _isFaculty = false;
  bool _isCoordinator = false;
  bool _isDean = false;
  List<CommunicatedTo> communicatedToList = List<CommunicatedTo>();

  @override
  Widget build(BuildContext context) {
    const List<String> _coordinators = [
      'Coordinator 1',
      'Coordinator 2',
      'Coordinator 3',
      'Coordinator 4',
    ];
    return (widget.grievanceAcademicAcademicAdvisor != null &&
                widget.grievanceAcademicAcademicAdvisor?.name != null &&
                widget.grievanceAcademicAcademicAdvisor?.name != "") ||
            (widget.selectedCourse != null)
        ? Column(
            children: [
              const Text(
                'Have you communicated your grievance with one or more of the following',
                style: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.selectedCourse != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Course Faculty',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Transform(
                          transform:
                              Matrix4.translationValues(DS.width * 0.04, 0, 0),
                          child: CircularCheckBox(
                            value: _isFaculty,
                            onChanged: (bool isFaculty) {
                              if (isFaculty) {
                                communicatedToList.add(CommunicatedTo()
                                  ..integerValue = 1
                                  ..stringValue =
                                      widget.selectedCourse?.facultyId ?? 0);
                              } else {
                                communicatedToList.removeWhere(
                                    (element) => element.integerValue == 1);
                              }
                              setState(() {
                                _isFaculty = isFaculty;
                              });
                              widget.communicatedToList(communicatedToList);
                            },
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: DS.height * 0.01),
                    Card(
                      color: Colors.white,
                      shadowColor: Colors.black38,
                      margin: const EdgeInsets.all(0.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(8.0))),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.selectedCourse == null
                              ? Image.asset(Images.girl)
                              : Image.memory(base64Decode(
                                  widget.selectedCourse.facultyImage)),
                        ),
                        title: Text(
                          widget.selectedCourse?.faculty ?? '',
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
                            widget.selectedCourse?.courseName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.blueGrey.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                              fontSize: DS.setSP(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.grievanceAcademicAcademicAdvisor != null &&
                  widget.grievanceAcademicAcademicAdvisor?.name != null &&
                  widget.grievanceAcademicAcademicAdvisor?.name != "")
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Academic Advisor',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Transform(
                          transform:
                              Matrix4.translationValues(DS.width * 0.04, 0, 0),
                          child: CircularCheckBox(
                            value: _isCoordinator,
                            onChanged: (bool isCoordinator) {
                              if (isCoordinator) {
                                communicatedToList.add(CommunicatedTo()
                                  ..integerValue = 2
                                  ..stringValue = widget
                                          .grievanceAcademicAcademicAdvisor
                                          ?.employeeId ??
                                      0);
                              } else {
                                communicatedToList.removeWhere(
                                    (element) => element.integerValue == 2);
                              }
                              setState(() {
                                _isCoordinator = isCoordinator;
                              });
                              widget.communicatedToList(communicatedToList);
                            },
                          ),
                        ),
                      ],
                    ),
                    Card(
                      color: Colors.white,
                      shadowColor: Colors.black38,
                      margin: const EdgeInsets.all(0.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(8.0))),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.grievanceAcademicAcademicAdvisor
                                          ?.advisorImage ==
                                      null ||
                                  widget?.grievanceAcademicAcademicAdvisor
                                          ?.advisorImage ==
                                      ""
                              ? Image.asset(Images.girl)
                              : Image.memory(base64Decode(widget
                                  .grievanceAcademicAcademicAdvisor
                                  .advisorImage)),
                        ),
                        title: Text(
                          widget.grievanceAcademicAcademicAdvisor?.name ?? '',
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
                            'Academic Advisor',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.blueGrey.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                              fontSize: DS.setSP(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.selectedCourse != null &&
                  widget.selectedCourse?.deanImage != null &&
                  widget.selectedCourse?.deanId != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedCourse == null ? '' : 'College Dean',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Transform(
                          transform:
                              Matrix4.translationValues(DS.width * 0.04, 0, 0),
                          child: CircularCheckBox(
                            value: _isDean,
                            onChanged: (bool isDean) {
                              if (isDean) {
                                communicatedToList.add(CommunicatedTo()
                                  ..integerValue = 3
                                  ..stringValue =
                                      widget.selectedCourse?.deanId ?? 0);
                              } else {
                                communicatedToList.removeWhere(
                                    (element) => element.integerValue == 3);
                              }
                              setState(() {
                                _isDean = isDean;
                              });
                              widget.communicatedToList(communicatedToList);
                            },
                          ),
                        ),
                      ],
                    ),
                    Card(
                      color: Colors.white,
                      shadowColor: Colors.black38,
                      margin: const EdgeInsets.all(0.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(8.0))),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.selectedCourse == null
                              ? Image.asset(Images.girl)
                              : Image.memory(base64Decode(
                                  widget.selectedCourse?.deanImage)),
                        ),
                        title: Text(
                          widget.selectedCourse?.dean ?? '',
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
                            widget.selectedCourse == null ? '' : 'College Dean',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.blueGrey.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                              fontSize: DS.setSP(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: DS.height * 0.01),
            ],
          )
        : const SizedBox();
  }
}
