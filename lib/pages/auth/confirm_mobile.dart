import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/pages/auth/mobile_verification.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/res/validators.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/mobile_verification_field.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmMobileScreen extends StatefulWidget {
  @override
  _ConfirmMobileScreenState createState() => _ConfirmMobileScreenState();
}

class _ConfirmMobileScreenState extends State<ConfirmMobileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();

  Widget _buildHelp() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
          border: Border.all(color: Colors.black)),
      child: Column(
        children: <Widget>[
          const Text(
            'A 6 digit "One-Time Password (OTP) will be sent to your registered mobile number. Once you submit the correct OTP you will be asked to enter new Password.',
            style: const TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w500),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10.0),
          const Text(
            'If you don\'t have access to this phone number, please contact University call center to change your phone number.\n800AUE (800-283)',
            style: const TextStyle(color: AppColors.blueGrey, fontSize: 15.0, fontWeight: FontWeight.w500),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
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
          context.read<AppStateNotifier>().user = null;
          return Future.delayed(Duration.zero, () => true);
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: LoginSingupCommon(
              headline: "Confirm Mobile",
              image: Images.confirm_phone,
              children: [
                ValidationField(
                  labelText: "Student Id",
                  validator: Validators.emptyValidator,
                  controller: _studentIdController,
                ),
                const SizedBox(height: 8.0),
                Consumer<AppStateNotifier>(
                  builder: (BuildContext context, AppStateNotifier notifier, _) {
                    return notifier.user != null
                        ? MobileVerificationField(
                            labelText: 'Mobile Number',
                            mobileNo: notifier.user.mobileNo1,
                            validator: (String text) {
                              if (text.isEmpty) {
                                return "Please Fill in the field";
                              }
                              if (text.length < 3) {
                                return "Must be three digits";
                              }

                              if (text.substring(text.length - 3) !=
                                  notifier.user.mobileNo1.substring(notifier.user.mobileNo1.length - 3)) {
                                return 'Last three digits does not match';
                              }

                              return null;
                            },
                          )
                        : const SizedBox();
//                  return notifier.user != null ? ValidationField(
//                    labelText: 'Mobile Number',
//                  ) : const SizedBox();
                  },
                ),
                const SizedBox(height: 18.0),
                Consumer<AppStateNotifier>(
                  builder: (BuildContext context, AppStateNotifier notifier, _) {
                    return PrimaryButton(
                      text: "Confirm",
                      width: DS.width,
                      viewState: notifier.viewState,
                      margin: const EdgeInsets.all(0.0),
                      onTap: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        if (notifier.user == null) {
                          await notifier.getStudentInformation(_studentIdController.text);
                        } else {
                          print('Send OTP');
                          await notifier.sendOTP(_studentIdController.text, notifier.user.mobileNo1, 6);
                          Get.to(MobileVerificationScreen(studentId: _studentIdController.text));
                        }

                        print('User Mobile1: ${notifier.user.mobileNo1}');
                      },
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                _buildHelp(),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
