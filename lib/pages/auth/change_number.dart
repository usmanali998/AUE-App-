import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/auth/change_number_verification.dart';
import 'package:aue/pages/tabs_view/dashboard/student_profile.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/res/validators.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/mobile_verification_field.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangeMobileNumberScreen extends StatefulWidget {
  @override
  _ChangeMobileNumberScreenState createState() => _ChangeMobileNumberScreenState();
}

class _ChangeMobileNumberScreenState extends State<ChangeMobileNumberScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPhoneNumber = TextEditingController();
  final TextEditingController _newPhoneNumber = TextEditingController();

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
          Get.back();
          return Future.delayed(Duration.zero, () => true);
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: LoginSingupCommon(
              headline: "Change Mobile no.",
              image: Images.verify_phone,
              children: [
                const SizedBox(height: 12.0),
                ValidationField(
                  labelText: "New Mobile Number",
                  obscureText: true,
                  controller: _newPhoneNumber,
                  validator: Validators.emptyValidator,
                ),
                const SizedBox(height: 18.0),
                Consumer<AppStateNotifier>(
                  builder: (BuildContext context, AppStateNotifier notifier, _) {
                    notifier.user = context.watch<AuthNotifier>().user;
                    return PrimaryButton(
                      text: "Change Phone Number",
                      width: DS.width,
                      viewState: notifier.viewState,
                      margin: const EdgeInsets.all(0.0),
                      onTap: () async {
                        if (!_formKey.currentState.validate()) {
                          print('invalidate');
                          return;
                        }
                        print('validate');
                        await notifier.sendOTP(notifier.user.studentID, _newPhoneNumber.text, 6);
                        Get.to(ChangeNumberVerificationScreen(studentId: notifier.user.studentID, newPhoneNumber: _newPhoneNumber.text,));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
