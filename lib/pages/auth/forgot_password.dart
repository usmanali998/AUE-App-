import 'package:aue/res/res.dart';
import 'package:aue/res/validators.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LoginSingupCommon(
          headline: "Forgot Password",
          image: Images.person,
          children: [
            ValidationField(
              labelText: "Username",
              validator: Validators.emptyValidator,
            ),
            SizedBox(height: 48),
            PrimaryButton(
              text: "Reset Password",
              width: DS.width,
            ),
          ],
        ),
      ),
    );
  }
}
