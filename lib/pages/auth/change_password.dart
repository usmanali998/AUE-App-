import 'package:aue/res/res.dart';
import 'package:aue/res/validators.dart';
import 'package:aue/widgets/login_sign_up_common.dart';
import 'package:aue/widgets/primary_button.dart';
import 'package:aue/widgets/validation_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {

  final String studentId;

  ChangePasswordScreen({@required this.studentId});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController _studentIdController;

  @override
  void initState() {
    _studentIdController = TextEditingController(text: widget.studentId);
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
        child: LoginSingupCommon(
          headline: "Change Password",
          image: Images.person,
          children: [
            ValidationField(
              labelText: "Username",
              validator: Validators.emptyValidator,
              controller: _studentIdController,
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
