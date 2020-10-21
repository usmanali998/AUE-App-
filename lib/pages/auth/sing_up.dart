import 'package:aue/pages/auth/login.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginSingupCommon(
          headline: "Welcome sign up",
          image: Images.person,
          children: [
            ValidationField(
              labelText: "Username",
              validator: Validators.emptyValidator,
            ),
            SizedBox(height: 24),
            ValidationField(
              labelText: "Password",
              obscureText: true,
              validator: Validators.emptyValidator,
            ),
            SizedBox(height: 16),
            SizedBox(height: 24),
            PrimaryButton(
              text: "Sign up",
              width: DS.width,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Don’t have a account? ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: DS.setSP(16),
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign in",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: DS.setSP(16),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("HELLO WORLD");
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
