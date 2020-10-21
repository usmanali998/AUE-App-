import 'package:aue/model/add_letter_request_model.dart';
import 'package:aue/model/letter_type.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/notifiers/base_notifier.dart';
import 'package:aue/pages/tabs_view/services/request_letter/request_letter_page.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_dropdown.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RequestForLetterPage extends StatefulWidget {
  @override
  _RequestForLetterPageState createState() => _RequestForLetterPageState();
}

class _RequestForLetterPageState extends State<RequestForLetterPage> {
  int _selectedLanguageId;
  bool _arabicCheckboxValue = false;
  bool _englishCheckboxValue = false;
  Future<List<LetterType>> _letterTypesFuture;
  LetterType _selectedLetterType;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAgreedToTerms = false;
  TextEditingController _subjectText = TextEditingController();
  TextEditingController _addressedToText = TextEditingController();
  TextEditingController _commentsText = TextEditingController();
  int _copies = 0;

  void getLetterTypes() {
    _letterTypesFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    _letterTypesFuture = Repository().getLetterTypes(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getLetterTypes();
  }

  Widget _buildLanguageCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Languages: ',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.translate(
              offset: Offset(-DS.width * 0.035, 0),
              child: Row(
                children: [
                  // const Text('Languages: '),
                  CircularCheckBox(
                    value: _arabicCheckboxValue,
                    onChanged: (bool value) {
                      setState(() {
                        _arabicCheckboxValue = value;
                        _englishCheckboxValue = !value;
                        _selectedLanguageId = 8;
                      });
                    },
                  ),
                  const Text(
                    'Arabic',
                    style: const TextStyle(
                      color: AppColors.blueGrey,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: DS.width * 0.2),
            Row(
              children: [
                CircularCheckBox(
                  value: _englishCheckboxValue,
                  onChanged: (bool value) {
                    setState(() {
                      _englishCheckboxValue = value;
                      _arabicCheckboxValue = !value;
                      _selectedLanguageId = 1;
                    });
                  },
                ),
                const Text(
                  'English',
                  style: const TextStyle(
                    color: AppColors.blueGrey,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCommentsTextField() {
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
          'Remarks / Comments',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: DS.height * 0.02),
        TextFormField(
          controller: _commentsText,
          decoration: InputDecoration(
            border: _inputBorder,
            focusedErrorBorder: _inputBorder,
            disabledBorder: _inputBorder,
            errorBorder: _inputBorder,
            contentPadding: const EdgeInsets.all(7.0),
            enabledBorder: _inputBorder,
            focusedBorder: _inputBorder,
            hintText: 'Write your comments',
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
    return SecondaryBackgroundWidget(
      title: 'Request for \nOfficial Letter',
      showBackButton: true,
      image: Images.classUpdates,
      isSingleChildScrollView: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: FutureBuilder<List<LetterType>>(
          future: _letterTypesFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<LetterType>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }
            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getLetterTypes(),
              );
            }
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  _buildLanguageCheckbox(),
                  SizedBox(height: DS.height * 0.01),
                  CustomDropdown<LetterType>(
                    dataList: snapshot.data,
                    label: 'Type: ',
                    textKey: 'Name',
                    onDataSelect: (LetterType selectedLetterType) {
                      setState(() {
                        _selectedLetterType = selectedLetterType;
                      });
                    },
                  ),
                  CustomTextField(
                      label: 'Subject: ',
                      hint: 'Provide Subject',
                      controller: _subjectText),
                  SizedBox(height: DS.height * 0.03),
                  CustomTextField(
                      label: 'Addressed To: ',
                      hint: 'Provide Address',
                      controller: _addressedToText),
                  SizedBox(height: DS.height * 0.03),
                  _buildCommentsTextField(),
                  SizedBox(height: DS.height * 0.02),
                  const Divider(
                    color: AppColors.blueGrey,
                    thickness: 1.7,
                  ),
                  SizedBox(height: DS.height * 0.02),
                  TotalFeesWidget(
                      letterType: _selectedLetterType,
                      copies: (int copies) {
                        _copies = copies;
                      }),
                  SizedBox(height: DS.height * 0.02),
                  TermsAndConditionsCheckboxes(
                    isAgreedToTerms: (bool isAgreedToTerms) {
                      _isAgreedToTerms = isAgreedToTerms;
                    },
                  ),
                  Consumer<AppStateNotifier>(
                    builder:
                        (BuildContext context, AppStateNotifier notifier, _) {
                      return notifier.viewState == ViewState.Busy
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 8.5),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Card(
                              color: Colors.white,
                              elevation: 4.0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(12.0))),
                              margin: const EdgeInsets.all(10.0).subtract(
                                  const EdgeInsets.symmetric(horizontal: 10)),
                              shadowColor: Colors.black38,
                              child: InkWell(
                                onTap: () async {
                                  bool isFormValid =
                                      this._formKey.currentState.validate();
                                  if (!isFormValid) {
                                    return;
                                  }
                                  notifier.viewState = notifier.setViewState(ViewState.Busy);

                                  if (this._selectedLanguageId == null) {
                                    print('language null');
                                    Fluttertoast.showToast(
                                      msg: 'Language must be selected.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: AppColors.blackGrey,
                                    );
                                    return;
                                  }

                                  if (!_isAgreedToTerms) {
                                    Fluttertoast.showToast(
                                      msg:
                                          'You must agree to both of the terms.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: AppColors.blackGrey,
                                    );
                                    return;
                                  }

                                  AddLetterRequestModel addLetterRequestModel =
                                      AddLetterRequestModel()
                                        ..studentId = context
                                            .read<AuthNotifier>()
                                            .user
                                            .studentID
                                        ..language = this._selectedLanguageId
                                        ..typeId = this._selectedLetterType.id
                                        ..subject = this._subjectText.text
                                        ..addressedTo =
                                            this._addressedToText.text
                                        ..comments = this._commentsText.text
                                        ..copies = _copies;
                                  String response = await Repository()
                                      .postLetterRequest(addLetterRequestModel);
                                  notifier.viewState = notifier.setViewState(ViewState.Idle);
                                  Get.off(RequestLetterPage(
                                    isGetRequests: true,
                                  ));
                                  if (response == null) {
                                    Fluttertoast.showToast(
                                      msg:
                                          'An error occurred while submitting request.',
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: AppColors.blackGrey,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: response,
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: AppColors.blackGrey,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Agree & Apply',
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
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String validationText;
  final TextEditingController controller;

  CustomTextField(
      {this.label, this.hint, this.controller, this.validationText});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
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
          widget.label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: _inputBorder,
                focusedErrorBorder: _inputBorder,
                disabledBorder: _inputBorder,
                errorBorder: _inputBorder,
                contentPadding: const EdgeInsets.all(.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
              validator: (String value) {
                print(value);
                if (value.isEmpty || value == null || value == '') {
                  if (widget.validationText != null) {
                    return widget.validationText;
                  }
                  return 'Enter ${widget.hint}';
                }
                return null;
              },
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class TotalFeesWidget extends StatefulWidget {
  final LetterType letterType;
  final void Function(int copies) copies;

  TotalFeesWidget({@required this.letterType, @required this.copies});

  @override
  _TotalFeesWidgetState createState() => _TotalFeesWidgetState();
}

class _TotalFeesWidgetState extends State<TotalFeesWidget> {
  int quantity = 1;

  double get totalFees {
    double eachCopyFee = widget?.letterType?.pricePerCopy ?? 0;
    if (widget.letterType == null) {
      return 0;
    }
    return quantity * eachCopyFee;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Fees: ${this.totalFees} AED',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
              color: Colors.transparent,
              border: Border.all(color: AppColors.blueGrey, width: 1.5)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (quantity == 1) {
                    return;
                  }
                  setState(() {
                    --quantity;
                  });
                  widget.copies(quantity);
                },
                child: const Icon(Icons.remove, color: AppColors.blueGrey),
              ),
              SizedBox(width: DS.width * 0.02),
              Text(
                quantity.toString(),
                style: const TextStyle(
                    color: AppColors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0),
              ),
              SizedBox(width: DS.width * 0.02),
              GestureDetector(
                onTap: () {
                  setState(() {
                    ++quantity;
                  });
                  widget.copies(quantity);
                },
                child: const Icon(Icons.add, color: AppColors.blueGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TermsAndConditionsCheckboxes extends StatefulWidget {
  final void Function(bool) isAgreedToTerms;

  TermsAndConditionsCheckboxes({this.isAgreedToTerms});

  @override
  _TermsAndConditionsCheckboxesState createState() =>
      _TermsAndConditionsCheckboxesState();
}

class _TermsAndConditionsCheckboxesState
    extends State<TermsAndConditionsCheckboxes> {
  bool _isInfoCorrect = false;
  bool _isAgree = false;

  @override
  void initState() {
    super.initState();
    widget.isAgreedToTerms(false);
  }

  @override
  Widget build(BuildContext context) {
    if (this._isInfoCorrect == false || this._isAgree == false) {
      widget.isAgreedToTerms(false);
    } else {
      widget.isAgreedToTerms(true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 18,
              child: CircularCheckBox(
                value: _isInfoCorrect,
                onChanged: (bool value) {
                  setState(() {
                    _isInfoCorrect = value;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
            SizedBox(width: DS.width * 0.04),
            Expanded(
              child: Text(
                'I hereby admit that all the information provided is correct',
                style: const TextStyle(
                  color: AppColors.blueGrey,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 18.0,
              child: CircularCheckBox(
                value: _isAgree,
                onChanged: (bool value) {
                  setState(() {
                    _isAgree = value;
                  });
                },
              ),
            ),
            SizedBox(width: DS.width * 0.04),
            Expanded(
              child: Text(
                'I agree to be charged for each copy of it.',
                style: const TextStyle(
                  color: AppColors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
