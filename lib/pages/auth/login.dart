import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/auth/confirm_mobile.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aue/pages/auth/forgot_password.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  void initState() {
//    usernameController = TextEditingController(text: "151210044");
//    passwordController = TextEditingController(text: "aueuat");
    usernameController = TextEditingController(text: "171210050");
    passwordController = TextEditingController(text: "aueuat");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LoginSingupCommon(
            headline: "Welcome Login",
            image: Images.person,
            children: [
              ValidationField(
                controller: usernameController,
                labelText: "Username",
                validator: Validators.emptyValidator,
              ),
              SizedBox(height: 24),
              ValidationField(
                controller: passwordController,
                labelText: "Password",
                obscureText: true,
                validator: Validators.passwordValidator,
              ),
              SizedBox(height: 16),
              ForgotPasswordRow(
                rememberMe: rememberMe,
                onChange: (val) {
                  rememberMe = val;
                  setState(() {});
                },
              ),
              SizedBox(height: 24),
              Consumer<AuthNotifier>(
                builder: (context, notifier, child) {
                  return PrimaryButton(
                    margin: EdgeInsets.zero,
                    viewState: notifier.viewState,
                    text: "Login",
                    width: DS.width,
                    onTap: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      await notifier.login(
                        usernameController.text,
                        passwordController.text,
                        rememberMe,
                      );

                      context.read<AppStateNotifier>().user = notifier.user;

                    },
                  );
                },
              ),
              SizedBox(height: 24),
              // Center(
              //   child: Text.rich(
              //     TextSpan(
              //       text: "Don’t have a account? ",
              //       style: TextStyle(
              //         color: Colors.black54,
              //         fontSize: DS.setSP(16),
              //         fontWeight: FontWeight.normal,
              //       ),
              //       children: [
              //         TextSpan(
              //           text: "Sign up",
              //           style: TextStyle(
              //             color: AppColors.primary,
              //             fontSize: DS.setSP(16),
              //             fontWeight: FontWeight.w600,
              //           ),
              //           recognizer: TapGestureRecognizer()
              //             ..onTap = () {
              //               Navigator.of(context).pop();
              //               Navigator.of(context).push(
              //                 MaterialPageRoute(
              //                   builder: (context) => SignUpScreen(),
              //                 ),
              //               );
              //             },
              //         ),
              //       ],
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordRow extends StatefulWidget {
  ForgotPasswordRow({
    Key key,
    @required this.rememberMe,
    this.onChange,
  }) : super(key: key);

  final bool rememberMe;
  final ValueChanged<bool> onChange;

  @override
  _ForgotPasswordRowState createState() => _ForgotPasswordRowState();
}

class _ForgotPasswordRowState extends State<ForgotPasswordRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CircularCheckBox(
                activeColor: AppColors.primary,
                value: widget.rememberMe,
                onChanged: widget.onChange,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    widget.onChange(!widget.rememberMe);
                  },
                  child: Text(
                    "Remember Me",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ConfirmMobileScreen(),
                ),
              );
            },
            child: Text(
              "Forgot Password?",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: DS.setSP(15),
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
