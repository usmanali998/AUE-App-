import 'dart:convert';
import 'dart:io';

import 'package:aue/model/apply_grant_semester_company.dart';
import 'package:aue/model/grant_details_semester.dart';
import 'package:aue/model/grant_details_semester_alumni.dart';
import 'package:aue/model/grant_details_semester_company.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/notifiers/base_notifier.dart';
import 'package:aue/pages/tabs_view/courses/widgets/course_withdrawal_attachments_widget.dart';
import 'package:aue/pages/tabs_view/services/request_letter/request_for_letter.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_dropdown.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class ApplyGrantPage extends StatefulWidget {
  final int discountTypeId;
  final int subTypeId;
  final String title;

  ApplyGrantPage({@required this.discountTypeId, @required this.subTypeId, @required this.title});

  @override
  _ApplyGrantPageState createState() => _ApplyGrantPageState();
}

class _ApplyGrantPageState extends State<ApplyGrantPage> {
  Future<GrantDetailsSemesterCompany> _grantDetailsSemesterCompanyFuture;
  Future<GrantDetailsSemester> _grantDetailsSemesterFuture;
  Future<GrantDetailsSemesterAlumni> _grantDetailsSemesterAlumniFuture;

  final GlobalKey<FormState> _grantDetailsSemesterCompanyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _grantDetailsSemesterFormKey = GlobalKey<FormState>();
  final TextEditingController _familyIdController = TextEditingController();
  final TextEditingController _alumniIdController = TextEditingController();

  CompanyList _selectedCompany;
  SemesterList _selectedSemester;
  int _discountPercentage;

  List<File> _selectedFiles;

  void getGrantDetailsSemesterCompany() {
    _grantDetailsSemesterCompanyFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _grantDetailsSemesterCompanyFuture = Repository().getGrantDetailsSemesterCompany(studentId, widget.discountTypeId, widget.subTypeId);
    setState(() {});
  }

  void getGrantDetailsSemester() {
    _grantDetailsSemesterFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _grantDetailsSemesterFuture = Repository().getGrantDetailsSemester(studentId, widget.discountTypeId, widget.subTypeId);
    setState(() {});
  }

  void getGrantDetailsSemesterAlumni() {
    _grantDetailsSemesterAlumniFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _grantDetailsSemesterAlumniFuture = Repository().getGrantDetailsSemesterAlumni(studentId, widget.discountTypeId, widget.subTypeId);
    setState(() {});
  }

  Future<void> _applyGrant(AppStateNotifier model) async {
    if (_grantDetailsSemesterCompanyFormKey?.currentState?.validate() ?? true == false) {
      print('InValid Semester Company');
      return;
    }
    if (!_grantDetailsSemesterFormKey.currentState.validate()) {
      print('InValid Semester');
      return;
    }
    model.setViewState(ViewState.Busy);
    if (widget.discountTypeId == 8 && widget.subTypeId == 11) {
      ApplyGrantSemesterCompany applyGrantSemesterCompany = ApplyGrantSemesterCompany()
        ..studentId = context.read<AuthNotifier>().user.studentID
        ..discountTypeId = widget.discountTypeId
        ..subTypeId = widget.subTypeId
        ..semesterId = _selectedSemester.semesterId
        ..discountPercentage = _discountPercentage
        ..suggestedCompanyName = ""
        ..alumniId = ""
        ..familyStudentId = ""
        ..companyId = _selectedCompany?.id ?? null
        ..attachments = _selectedFiles.map((File file) {
          return Attachment()
            ..stringValue = path.basename(file.path)
            ..byteValues = base64Encode(file.readAsBytesSync());
        }).toList();

      try {
        String result = await Repository().applyGrantSemesterCompany(applyGrantSemesterCompany, (int count, int total) {
          if (count == total) {
            model.setViewState(ViewState.Idle);
          }
        });
        Get.back();
        Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        Fluttertoast.showToast(msg: (e as DioError).response.data, toastLength: Toast.LENGTH_LONG);
        Get.back();
      }
    }
    else if (widget.discountTypeId == 6 && widget.subTypeId == 6) {
      ApplyGrantSemesterCompany applyGrantSemesterCompany = ApplyGrantSemesterCompany()
        ..studentId = context.read<AuthNotifier>().user.studentID
        ..discountTypeId = widget.discountTypeId
        ..subTypeId = widget.subTypeId
        ..semesterId = _selectedSemester.semesterId
        ..discountPercentage = _discountPercentage
        ..suggestedCompanyName = ""
        ..alumniId = ""
        ..familyStudentId = _familyIdController?.text ?? ""
        ..companyId = _selectedCompany?.id ?? 0
        ..attachments = _selectedFiles.map((File file) {
          return Attachment()
            ..stringValue = path.basename(file.path)
            ..byteValues = base64Encode(file.readAsBytesSync());
        }).toList();

      try {
        String result = await Repository().applyGrantSemesterCompany(applyGrantSemesterCompany, (int count, int total) {
          if (count == total) {
            model.setViewState(ViewState.Idle);
            Get.back();
          }
        });
        Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        Fluttertoast.showToast(msg: (e as DioError).response.data, toastLength: Toast.LENGTH_LONG);
        Get.back();
      }
    }
    else if (widget.discountTypeId == 28 && widget.subTypeId == 16) {
      ApplyGrantSemesterCompany applyGrantSemesterCompany = ApplyGrantSemesterCompany()
        ..studentId = context.read<AuthNotifier>().user.studentID
        ..discountTypeId = widget.discountTypeId
        ..subTypeId = widget.subTypeId
        ..semesterId = _selectedSemester.semesterId
        ..discountPercentage = _discountPercentage
        ..suggestedCompanyName = ""
        ..alumniId = _alumniIdController?.text ?? ""
        ..familyStudentId = _familyIdController?.text ?? ""
        ..companyId = _selectedCompany?.id ?? 0
        ..attachments = _selectedFiles.map((File file) {
          return Attachment()
            ..stringValue = path.basename(file.path)
            ..byteValues = base64Encode(file.readAsBytesSync());
        }).toList();

      try {
        String result = await Repository().applyGrantSemesterCompany(applyGrantSemesterCompany, (int count, int total) {
          if (count == total) {
            model.setViewState(ViewState.Idle);
            Get.back();
          }
        });
        Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        Fluttertoast.showToast(msg: (e as DioError).response.data, toastLength: Toast.LENGTH_LONG);
        Get.back();
      }
    }
    else {
      ApplyGrantSemesterCompany applyGrantSemesterCompany = ApplyGrantSemesterCompany()
        ..studentId = context.read<AuthNotifier>().user.studentID
        ..discountTypeId = widget.discountTypeId
        ..subTypeId = widget.subTypeId
        ..semesterId = _selectedSemester.semesterId
        ..discountPercentage = _discountPercentage
        ..suggestedCompanyName = ""
        ..alumniId = _alumniIdController?.text ?? 0
        ..familyStudentId = _familyIdController?.text ?? 0
        ..companyId = _selectedCompany?.id ?? 0
        ..attachments = _selectedFiles.map((File file) {
          return Attachment()
            ..stringValue = path.basename(file.path)
            ..byteValues = base64Encode(file.readAsBytesSync());
        }).toList();

      try {
        String result = await Repository().applyGrantSemesterCompany(applyGrantSemesterCompany, (int count, int total) {
          if (count == total) {
            model.setViewState(ViewState.Idle);
            Get.back();
          }
        });
        Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        Fluttertoast.showToast(msg: (e as DioError).response.data, toastLength: Toast.LENGTH_LONG);
        Get.back();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.discountTypeId == 8 && widget.subTypeId == 11) {
      this.getGrantDetailsSemesterCompany();
    } else if (widget.discountTypeId == 6 && widget.subTypeId == 6) {
      this.getGrantDetailsSemester();
    } else if (widget.discountTypeId == 28 && widget.subTypeId == 16) {
      this.getGrantDetailsSemesterAlumni();
    } else {
      this.getGrantDetailsSemester();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: widget.title,
      image: Images.classUpdates,
      isSingleChildScrollView: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: widget.discountTypeId == 8 && widget.subTypeId == 11
            ? FutureBuilder<GrantDetailsSemesterCompany>(
                future: _grantDetailsSemesterCompanyFuture,
                builder: (BuildContext context, AsyncSnapshot<GrantDetailsSemesterCompany> snapshot) {
                  if (snapshot.isLoading) {
                    return Center(
                      child: LoadingWidget(),
                    );
                  }
                  if (snapshot.hasError && snapshot.error != null) {
                    return CustomErrorWidget(
                      err: snapshot.error,
                      onRetryTap: () => this.getGrantDetailsSemesterCompany(),
                    );
                  }
                  _discountPercentage = snapshot.data.details.first.percentage.toInt();
                  return Form(
                    key: _grantDetailsSemesterCompanyFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GRANT REQUEST',
                          style: const TextStyle(
                            color: AppColors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (snapshot.data.details.first.showCompanyList)
                          Column(
                            children: [
                              SizedBox(height: DS.height * 0.03),
                              CustomDropdown<CompanyList>(
                                label: 'Company Name',
                                textKey: 'Name',
                                onDataSelect: (CompanyList company) {
                                  _selectedCompany = company;
                                },
                                dataList: snapshot.data.companyList,
                              ),
                            ],
                          ),
                        SizedBox(height: DS.height * 0.02),
                        CustomDropdown<SemesterList>(
                          label: 'Select Semester To Apply Discount: ',
                          textKey: 'SemesterName',
                          validationText: 'Select Semester',
                          onDataSelect: (SemesterList semester) {
                            _selectedSemester = semester;
                          },
                          dataList: snapshot.data.semesterList,
                        ),
                        CourseWithdrawalAttachmentsWidget(
                          onFilesSelected: (List<File> files) {
                            _selectedFiles = files;
                          },
                          label: 'Supporting Document: ',
                        ),
                        SizedBox(height: DS.height * 0.03),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 4.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
                              child: Text(
                                snapshot.data.details.first.description + '\n\n' + snapshot.data.details.first.disclaimer,
                                style: const TextStyle(
                                  color: AppColors.blueGrey,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: DS.height * 0.03),
                        Consumer<AppStateNotifier>(
                          builder: (BuildContext context, AppStateNotifier model, _) {
                            return model.viewState == ViewState.Busy
                                ? const CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: () async {
                                      await this._applyGrant(model);
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
                                              'Agree and Apply',
                                              style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.fromBorderSide(
                                                  const BorderSide(
                                                    color: AppColors.primary,
                                                    width: 1.5,
                                                  ),
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
                          // child: GestureDetector(
                          //   onTap: () async {
                          //     await this._applyGrant();
                          //   },
                          //   child: Card(
                          //     color: Colors.white,
                          //     elevation: 4.0,
                          //     shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                          //     margin: const EdgeInsets.all(0.0),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(12.0),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           const Text(
                          //             'Agree and Apply',
                          //             style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                          //           ),
                          //           Container(
                          //             decoration: const BoxDecoration(
                          //               color: Colors.transparent,
                          //               shape: BoxShape.circle,
                          //               border: Border.fromBorderSide(
                          //                 const BorderSide(
                          //                   color: AppColors.primary,
                          //                   width: 1.5,
                          //                 ),
                          //               ),
                          //             ),
                          //             child: const Icon(
                          //               Icons.arrow_forward,
                          //               color: AppColors.primary,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : widget.discountTypeId == 6 && widget.subTypeId == 6
                ? FutureBuilder<GrantDetailsSemester>(
                    future: _grantDetailsSemesterFuture,
                    builder: (BuildContext context, AsyncSnapshot<GrantDetailsSemester> snapshot) {
                      if (snapshot.isLoading) {
                        return Center(
                          child: LoadingWidget(),
                        );
                      }
                      if (snapshot.hasError && snapshot.error != null) {
                        return CustomErrorWidget(
                          err: snapshot.error,
                          onRetryTap: () => this.getGrantDetailsSemester(),
                        );
                      }
                      _discountPercentage = snapshot.data.details.first.percentage.toInt();
                      return Form(
                        key: _grantDetailsSemesterFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GRANT REQUEST',
                              style: const TextStyle(
                                color: AppColors.blueGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (snapshot.data.details.first.showFamilyAueidNumber)
                              Column(
                                children: [
                                  SizedBox(height: DS.height * 0.03),
                                  CustomTextField(
                                    controller: _familyIdController,
                                    label: snapshot.data?.details?.first?.familyAueidNumberLabel,
                                    hint: snapshot.data?.details?.first?.familyAueidNumberLabel,
                                    validationText: 'Enter ${snapshot.data?.details?.first?.familyAueidNumberLabel}',
                                  ),
                                ],
                              ),
                            SizedBox(height: DS.height * 0.02),
                            CustomDropdown<SemesterList>(
                              label: 'Select Semester To Apply Discount: ',
                              textKey: 'SemesterName',
                              validationText: 'Select Semester',
                              onDataSelect: (SemesterList semester) {
                                _selectedSemester = semester;
                              },
                              dataList: snapshot.data.semesterList,
                            ),
                            CourseWithdrawalAttachmentsWidget(
                              onFilesSelected: (List<File> files) {
                                _selectedFiles = files;
                              },
                              label: 'Supporting Document: ',
                            ),
                            SizedBox(height: DS.height * 0.03),
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                elevation: 4.0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(6.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
                                  child: Text(
                                    snapshot.data.details.first.description + '\n\n' + snapshot.data.details.first.disclaimer,
                                    style: const TextStyle(
                                      color: AppColors.blueGrey,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: DS.height * 0.03),
                            Consumer<AppStateNotifier>(
                              builder: (BuildContext context, AppStateNotifier model, _) {
                                return model.viewState == ViewState.Busy
                                    ? const CircularProgressIndicator()
                                    : GestureDetector(
                                        onTap: () async {
                                          await this._applyGrant(model);
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
                                                  'Agree and Apply',
                                                  style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    border: Border.fromBorderSide(
                                                      const BorderSide(
                                                        color: AppColors.primary,
                                                        width: 1.5,
                                                      ),
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
                              // child: GestureDetector(
                              //   onTap: () async {
                              //     await this._applyGrant();
                              //   },
                              //   child: Card(
                              //     color: Colors.white,
                              //     elevation: 4.0,
                              //     shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                              //     margin: const EdgeInsets.all(0.0),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(12.0),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           const Text(
                              //             'Agree and Apply',
                              //             style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                              //           ),
                              //           Container(
                              //             decoration: const BoxDecoration(
                              //               color: Colors.transparent,
                              //               shape: BoxShape.circle,
                              //               border: Border.fromBorderSide(
                              //                 const BorderSide(
                              //                   color: AppColors.primary,
                              //                   width: 1.5,
                              //                 ),
                              //               ),
                              //             ),
                              //             child: const Icon(
                              //               Icons.arrow_forward,
                              //               color: AppColors.primary,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : widget.discountTypeId == 28 && widget.subTypeId == 16
                    ? FutureBuilder<GrantDetailsSemesterAlumni>(
                        future: _grantDetailsSemesterAlumniFuture,
                        builder: (BuildContext context, AsyncSnapshot<GrantDetailsSemesterAlumni> snapshot) {
                          if (snapshot.isLoading) {
                            return Center(
                              child: LoadingWidget(),
                            );
                          }
                          if (snapshot.hasError && snapshot.error != null) {
                            return CustomErrorWidget(
                              err: snapshot.error,
                              onRetryTap: () => this.getGrantDetailsSemester(),
                            );
                          }
                          _discountPercentage = snapshot.data.details.first.percentage.toInt();
                          return Form(
                            key: _grantDetailsSemesterFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GRANT REQUEST',
                                  style: const TextStyle(
                                    color: AppColors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (snapshot.data.details.first.showPreviousAueidNumber)
                                  Column(
                                    children: [
                                      SizedBox(height: DS.height * 0.03),
                                      CustomTextField(
                                        controller: _alumniIdController,
                                        label: snapshot.data?.details?.first?.previousAueidNumberLabel,
                                        hint: snapshot.data?.details?.first?.previousAueidNumberLabel,
                                        validationText: 'Enter ${snapshot.data?.details?.first?.previousAueidNumberLabel}',
                                      ),
                                    ],
                                  ),
                                SizedBox(height: DS.height * 0.02),
                                CustomDropdown<SemesterList>(
                                  label: 'Select Semester To Apply Discount: ',
                                  textKey: 'SemesterName',
                                  validationText: 'Select Semester',
                                  onDataSelect: (SemesterList semester) {
                                    _selectedSemester = semester;
                                  },
                                  dataList: snapshot.data.semesterList,
                                ),
                                CourseWithdrawalAttachmentsWidget(
                                  onFilesSelected: (List<File> files) {
                                    _selectedFiles = files;
                                  },
                                  label: 'Supporting Document: ',
                                ),
                                SizedBox(height: DS.height * 0.03),
                                SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 4.0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(6.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
                                      child: Text(
                                        snapshot.data.details.first.description + '\n\n' + snapshot.data.details.first.disclaimer,
                                        style: const TextStyle(
                                          color: AppColors.blueGrey,
                                          fontSize: 14.0,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: DS.height * 0.03),
                                Consumer<AppStateNotifier>(
                                  builder: (BuildContext context, AppStateNotifier model, _) {
                                    return model.viewState == ViewState.Busy
                                        ? const CircularProgressIndicator()
                                        : GestureDetector(
                                            onTap: () async {
                                              await this._applyGrant(model);
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
                                                      'Agree and Apply',
                                                      style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.fromBorderSide(
                                                          const BorderSide(
                                                            color: AppColors.primary,
                                                            width: 1.5,
                                                          ),
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
                                  // child: GestureDetector(
                                  //   onTap: () async {
                                  //     await this._applyGrant();
                                  //   },
                                  //   child: Card(
                                  //     color: Colors.white,
                                  //     elevation: 4.0,
                                  //     shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                                  //     margin: const EdgeInsets.all(0.0),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(12.0),
                                  //       child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           const Text(
                                  //             'Agree and Apply',
                                  //             style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                  //           ),
                                  //           Container(
                                  //             decoration: const BoxDecoration(
                                  //               color: Colors.transparent,
                                  //               shape: BoxShape.circle,
                                  //               border: Border.fromBorderSide(
                                  //                 const BorderSide(
                                  //                   color: AppColors.primary,
                                  //                   width: 1.5,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             child: const Icon(
                                  //               Icons.arrow_forward,
                                  //               color: AppColors.primary,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : FutureBuilder<GrantDetailsSemester>(
          future: _grantDetailsSemesterFuture,
          builder: (BuildContext context, AsyncSnapshot<GrantDetailsSemester> snapshot) {
            if (snapshot.isLoading) {
              return Center(
                child: LoadingWidget(),
              );
            }
            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getGrantDetailsSemester(),
              );
            }
            _discountPercentage = snapshot.data.details.first.percentage.toInt();
            return Form(
              key: _grantDetailsSemesterFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GRANT REQUEST',
                    style: const TextStyle(
                      color: AppColors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (snapshot.data.details.first.showFamilyAueidNumber)
                    Column(
                      children: [
                        SizedBox(height: DS.height * 0.03),
                        CustomTextField(
                          controller: _familyIdController,
                          label: snapshot.data?.details?.first?.familyAueidNumberLabel,
                          hint: snapshot.data?.details?.first?.familyAueidNumberLabel,
                          validationText: 'Enter ${snapshot.data?.details?.first?.familyAueidNumberLabel}',
                        ),
                      ],
                    ),
                  SizedBox(height: DS.height * 0.02),
                  CustomDropdown<SemesterList>(
                    label: 'Select Semester To Apply Discount: ',
                    textKey: 'SemesterName',
                    validationText: 'Select Semester',
                    onDataSelect: (SemesterList semester) {
                      _selectedSemester = semester;
                    },
                    dataList: snapshot.data.semesterList,
                  ),
                  CourseWithdrawalAttachmentsWidget(
                    onFilesSelected: (List<File> files) {
                      _selectedFiles = files;
                    },
                    label: 'Supporting Document: ',
                  ),
                  SizedBox(height: DS.height * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(6.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
                        child: Text(
                          snapshot.data.details.first.description + '\n\n' + snapshot.data.details.first.disclaimer,
                          style: const TextStyle(
                            color: AppColors.blueGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: DS.height * 0.03),
                  Consumer<AppStateNotifier>(
                    builder: (BuildContext context, AppStateNotifier model, _) {
                      return model.viewState == ViewState.Busy
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                        onTap: () async {
                          await this._applyGrant(model);
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
                                  'Agree and Apply',
                                  style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(
                                      const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
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
                    // child: GestureDetector(
                    //   onTap: () async {
                    //     await this._applyGrant();
                    //   },
                    //   child: Card(
                    //     color: Colors.white,
                    //     elevation: 4.0,
                    //     shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                    //     margin: const EdgeInsets.all(0.0),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(12.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           const Text(
                    //             'Agree and Apply',
                    //             style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                    //           ),
                    //           Container(
                    //             decoration: const BoxDecoration(
                    //               color: Colors.transparent,
                    //               shape: BoxShape.circle,
                    //               border: Border.fromBorderSide(
                    //                 const BorderSide(
                    //                   color: AppColors.primary,
                    //                   width: 1.5,
                    //                 ),
                    //               ),
                    //             ),
                    //             child: const Icon(
                    //               Icons.arrow_forward,
                    //               color: AppColors.primary,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              ),
            );
          },
        )
      ),
    );
  }
}

// class ApplyGrantCompanyDropdown extends StatefulWidget {
//   final Function(CourseWithdrawalReason) onReasonSelect;
//
//   ApplyGrantCompanyDropdown({@required this.onReasonSelect});
//
//   @override
//   _ApplyGrantCompanyDropdownState createState() => _ApplyGrantCompanyDropdownState();
// }
//
// class _ApplyGrantCompanyDropdownState extends State<ApplyGrantCompanyDropdown> {
//   Future<List<CourseWithdrawalReason>> _courseWithdrawalReasonsFuture;
//   CourseWithdrawalReason _selectedReason;
//
//   @override
//   void initState() {
//     getCourseWithdrawalReasons();
//     super.initState();
//   }
//
//   void getCourseWithdrawalReasons() {
//     _courseWithdrawalReasonsFuture = null;
//     _courseWithdrawalReasonsFuture = Repository().getCourseWithdrawalReasons();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<CourseWithdrawalReason>>(
//       future: _courseWithdrawalReasonsFuture,
//       builder: (BuildContext context, AsyncSnapshot<List<CourseWithdrawalReason>> snapshot) {
//         if (snapshot.isLoading) {
//           return const LoadingWidget();
//         }
//
//         if (snapshot.hasError && snapshot.error != null) {
//           return CustomErrorWidget(
//             err: DioError(
//               error: snapshot.error,
//               type: DioErrorType.RESPONSE,
//               response: Response<String>(data: snapshot.error),
//             ),
//             onRetryTap: () => getCourseWithdrawalReasons(),
//           );
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Company Name',
//               style: const TextStyle(
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15.0,
//               ),
//             ),
//             DropdownButton<CourseWithdrawalReason>(
//               items: snapshot.data.map<DropdownMenuItem<CourseWithdrawalReason>>(
//                 (CourseWithdrawalReason reason) {
//                   return DropdownMenuItem<CourseWithdrawalReason>(
//                     child: Text(
//                       reason.reasonTypeEn,
//                       style: const TextStyle(
//                         color: AppColors.blueGrey,
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     value: reason,
//                   );
//                 },
//               ).toList(),
//               value: _selectedReason,
//               hint: const Text(
//                 'Select Reason Category',
//                 style: const TextStyle(
//                   color: AppColors.blueGrey,
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               style: const TextStyle(
//                 color: AppColors.blueGrey,
//                 fontSize: 14.0,
//                 fontWeight: FontWeight.w700,
//               ),
//               onChanged: (CourseWithdrawalReason reason) {
//                 _selectedReason = reason;
//                 setState(() {});
//                 widget.onReasonSelect(reason);
//               },
//               icon: Container(
//                 decoration: const BoxDecoration(
//                   borderRadius: const BorderRadius.all(
//                     const Radius.circular(30.0),
//                   ),
//                   color: Colors.transparent,
//                   border: const Border.fromBorderSide(
//                     const BorderSide(color: AppColors.blueGrey, width: 1.3),
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.keyboard_arrow_down,
//                   size: 20,
//                 ),
//               ),
//               isExpanded: true,
//               underline: const SizedBox(),
//             ),
//             Container(
//               transform: Matrix4.translationValues(0, -12, 0),
//               child: const Divider(
//                 color: AppColors.blueGrey,
//                 thickness: 1.1,
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
//
// class ApplyGrantSemesterDropdown extends StatefulWidget {
//   final List<SemesterList> semestersList;
//   final void Function(SemesterList) onSemesterSelect;
//
//   ApplyGrantSemesterDropdown({@required this.semestersList, this.onSemesterSelect});
//
//   @override
//   _ApplyGrantSemesterDropdownState createState() => _ApplyGrantSemesterDropdownState();
// }
//
// class _ApplyGrantSemesterDropdownState extends State<ApplyGrantSemesterDropdown> {
//   SemesterList _selectedSemester;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Select Semester to Apply Discount: ',
//           style: const TextStyle(
//             color: AppColors.primary,
//             fontWeight: FontWeight.w600,
//             fontSize: 15.0,
//           ),
//         ),
//         DropdownButton<SemesterList>(
//           items: this.widget.semestersList.map<DropdownMenuItem<SemesterList>>(
//             (SemesterList semester) {
//               return DropdownMenuItem<SemesterList>(
//                 child: Text(
//                   semester.semesterName,
//                   style: const TextStyle(
//                     color: AppColors.blueGrey,
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 value: semester,
//               );
//             },
//           ).toList(),
//           value: _selectedSemester,
//           hint: const Text(
//             'Select Semester',
//             style: const TextStyle(
//               color: AppColors.blueGrey,
//               fontSize: 14.0,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           style: const TextStyle(
//             color: AppColors.blueGrey,
//             fontSize: 14.0,
//             fontWeight: FontWeight.w700,
//           ),
//           onChanged: (SemesterList semester) {
//             _selectedSemester = semester;
//             setState(() {});
//             widget.onSemesterSelect(semester);
//           },
//           icon: Container(
//             decoration: const BoxDecoration(
//               borderRadius: const BorderRadius.all(
//                 const Radius.circular(30.0),
//               ),
//               color: Colors.transparent,
//               border: const Border.fromBorderSide(
//                 const BorderSide(color: AppColors.blueGrey, width: 1.3),
//               ),
//             ),
//             child: const Icon(
//               Icons.keyboard_arrow_down,
//               size: 20,
//             ),
//           ),
//           isExpanded: true,
//           underline: const SizedBox(),
//         ),
//         Container(
//           transform: Matrix4.translationValues(0, -12, 0),
//           child: const Divider(
//             color: AppColors.blueGrey,
//             thickness: 1.1,
//           ),
//         )
//       ],
//     );
//   }
// }
