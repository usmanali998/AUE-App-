import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/pages/auth/login.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/validators.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmPasswordScreen extends StatefulWidget {

  final String studentId;

  ConfirmPasswordScreen({@required this.studentId});

  @override
  _ConfirmPasswordScreenState createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _choosePasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
          Get.offAll(LoginPage());
          return Future.delayed(Duration.zero, () => true);
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: LoginSingupCommon(
              headline: "Confirm Password",
              image: Images.lock,
              children: [
                ValidationField(
                  labelText: "Choose Password",
                  validator: Validators.emptyValidator,
                  obscureText: true,
                  controller: _choosePasswordController,
                ),
                const SizedBox(height: 12.0),
                ValidationField(
                  labelText: "Confirm Password",
                  validator: (String text) {
                    if (_choosePasswordController.text != _confirmPasswordController.text) {
                      return "Password does not match";
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 18.0),
                Consumer<AppStateNotifier>(
                  builder: (BuildContext context, AppStateNotifier notifier, _) {
                    return PrimaryButton(
                      text: "Save Password",
                      width: DS.width,
                      viewState: notifier.viewState,
                      margin: const EdgeInsets.all(0.0),
                      onTap: () async {
                        if (!_formKey.currentState.validate()) {
                          print('invalidate');
                          return;
                        }
                        print('validate');
                        await notifier.changeStudentPassword(widget.studentId, _confirmPasswordController.text);
                        Get.offAll(LoginPage());
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
