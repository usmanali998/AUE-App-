import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/pages/auth/confirm_password.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileVerificationScreen extends StatefulWidget {
  final String studentId;

  MobileVerificationScreen({@required this.studentId});

  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final TextEditingController _sixDigitsOTPController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    _sixDigitsOTPController.addListener(() {
      setState(() {});
    });
    _sixDigitsOTPController.addListener(_verifyOTP);
    _focus.addListener(this._onFocusChange);
    super.initState();
  }

  void _verifyOTP() async {
    if (_sixDigitsOTPController.text.length == 6 && _focus.hasFocus) {
      await context.read<AppStateNotifier>().verifyOTPAndUpdateStatus(widget.studentId, _sixDigitsOTPController.text);
    }
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  String validator() {
//    if (_sixDigitsOTPController.text.isEmpty || _sixDigitsOTPController.text == '') {
//      return null;
//    }
    if (_sixDigitsOTPController.text.length < 6) {
      return " ";
    }

    return null;
  }

  Widget _buildOneTimePin() {
//    final bool isValidated = this.validator() == null;
    final bool isValidated = context.watch<AppStateNotifier>().isOTPVerified && validator() == null;
    final InputBorder _lastThreeDigitsBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 2.5, color: isValidated ? AppColors.green : AppColors.red),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'ENTER ONE TIME PIN',
          style: const TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: isValidated ? DS.width * 0.05 : 0.0),
              SizedBox(
                width: DS.width * 0.3,
                child: TextFormField(
                  focusNode: _focus,
                  controller: _sixDigitsOTPController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  buildCounter: (BuildContext context, {int currentLength, bool isFocused, int maxLength}) {
                    return null;
                  },
                  validator: (String text) {
//              if (text != widget.mobileNo.substring(widget.mobileNo.length - 3)) {
//                return '';
//              }

                    return null;
                  },
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: DS.setSP(18),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 10,
                  ),
                  decoration: InputDecoration(
                    labelText: '',
                    labelStyle: TextStyle(
                      color: _focus.hasFocus ? Colors.black : AppColors.primary.withOpacity(0.5),
                      height: 0.8,
                    ),
                    disabledBorder: _lastThreeDigitsBorder,
                    border: _lastThreeDigitsBorder,
                    focusedErrorBorder: _lastThreeDigitsBorder,
                    enabledBorder: _lastThreeDigitsBorder,
                    errorBorder: _lastThreeDigitsBorder,
                    focusedBorder: _lastThreeDigitsBorder,
                  ),
                ),
              ),
              isValidated
                  ? Container(
                      margin: EdgeInsets.only(top: DS.width * 0.05),
                      padding: const EdgeInsets.all(2.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green,
                      ),
                      child: const Icon(Icons.done, color: Colors.white, size: 17.0),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResendOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Didn\'t receive the verification OTP?',
          style: const TextStyle(color: AppColors.blueGrey, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            await context
                .read<AppStateNotifier>()
                .sendOTP(widget.studentId, context.read<AppStateNotifier>().user.mobileNo1, 6);
            _sixDigitsOTPController.clear();
            Get.snackbar("OTP Code", "A new OTP code has been sent!");
          },
          child: const Text(
            'Resend again',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: WillPopScope(
        onWillPop: () {
          print('on mobile verification back');
          context.read<AppStateNotifier>().user = null;
          context.read<AppStateNotifier>().notifyListeners();
          return Future.delayed(Duration.zero, () => true);
        },
        child: SafeArea(
          child: LoginSingupCommon(
            headline: "Mobile Verification",
            image: Images.verify_phone,
            children: [
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: _buildOneTimePin(),
              ),
              const SizedBox(height: 8.0),
              Consumer<AppStateNotifier>(
                builder: (BuildContext context, AppStateNotifier notifier, _) {
                  return notifier.user != null ? const SizedBox() : const SizedBox();
                },
              ),
              const SizedBox(height: 18.0),
              Consumer<AppStateNotifier>(
                builder: (BuildContext context, AppStateNotifier notifier, _) {
                  return PrimaryButton(
                    text: "Change Password",
                    width: DS.width,
                    viewState: notifier.viewState,
                    margin: const EdgeInsets.all(0.0),
                    onTap: () async {
                      if (notifier.isOTPVerified && validator() == null) {
                        Get.to(ConfirmPasswordScreen(studentId: widget.studentId));
                      }
                      print('User Mobile1: ${notifier.user.mobileNo1}');
                    },
                  );
                },
              ),
              SizedBox(height: DS.height * 0.03),
              Align(
                alignment: Alignment.center,
                child: _buildResendOTP(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
