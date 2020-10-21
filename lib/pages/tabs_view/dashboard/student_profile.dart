import 'dart:convert';
import 'dart:typed_data';

import 'package:aue/model/student_profile_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/auth/change_number.dart';
import 'package:aue/pages/auth/change_password.dart';
import 'package:aue/pages/auth/confirm_mobile.dart';
import 'package:aue/pages/auth/forgot_password.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aue/res/extensions.dart';
import 'package:dio/dio.dart';

class StudentProfileScreen extends StatefulWidget {
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  Future<StudentProfile> _studentProfileFuture;

  @override
  void initState() {
    getStudentProfile();
    super.initState();
  }

  void getStudentProfile() {
    _studentProfileFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    _studentProfileFuture = Repository.getStudentProfile(studentId);
    setState(() {});
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: const Icon(Icons.arrow_back, color: Colors.white),
            onTap: () {
              Get.back();
            },
          ),
          SizedBox(width: DS.width * 0.22),
          const Text(
            'Student Profile',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData iconData, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: FlatButton(
        onPressed: onTap,
        splashColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(10.0))),
        padding: const EdgeInsets.all(12.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(iconData, color: AppColors.primary, size: 30.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthNotifier>(builder: (BuildContext context, AuthNotifier notifier, _) {
        return FutureBuilder<StudentProfile>(
          future: _studentProfileFuture,
          builder: (BuildContext context, AsyncSnapshot<StudentProfile> snapshot) {
            if (snapshot.isLoading) {
              return Align(
                alignment: Alignment.center,
                child: const LoadingWidget(),
              );
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: DioError(
                  error: 'Error Retrieving Student Profile',
                  type: DioErrorType.RESPONSE,
                  response: Response<String>(data: 'Error Retrieving Student Profile'),
                ),
                onRetryTap: () => this.getStudentProfile(),
              );
            }

            context.watch<AuthNotifier>().user.mobileNo1 = notifier.user.mobileNo1;

            return BackgroundWidget(
              children: <Widget>[
                _buildHeader(),
                MainProfileCard(
                  profilePicture: base64.decode(snapshot.data.imageThumbnail),
                  studentName: snapshot.data.fullName,
                  studentId: snapshot.data.studentId,
                  email: snapshot.data.email,
                  phoneNumber: snapshot.data.mobileNumber,
                  date: snapshot.data.dateOfBirth,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 12.0),
                  child: const Text(
                    'ACADEMIC INFORMATION',
                    style: const TextStyle(
                      color: AppColors.blueGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AcademicInformation(
                  college: snapshot.data.college,
                  degree: snapshot.data.degree,
                  specialization: snapshot.data.specialization,
                  englishProficiencyLevel: snapshot.data.englishLevel,
                  englishScore: snapshot.data.englishScore,
                  academicAdvisor: snapshot.data.studentAdvisor,
                  cgpa: snapshot.data.cgpa,
                ),
                _buildButton('Change Password', Icons.lock_outline, () {
                  Get.to(
                    ConfirmMobileScreen()
                    // ForgotPasswordScreen()
                    // ChangePasswordScreen(studentId: snapshot.data.studentId),
                  );
                }),
                _buildButton('Sign Out', Icons.error_outline, () async {
                  await context.read<AuthNotifier>().logout();
                }),
                SizedBox(height: DS.height * 0.2),
              ],
            );
          },
        );
      }),
    );
  }
}

class MainProfileCard extends StatelessWidget {
  final Uint8List profilePicture;
  final String studentName;
  final String studentId;
  final String email;
  final String phoneNumber;
  final DateTime date;

  const MainProfileCard({
    this.studentId,
    this.phoneNumber,
    this.email,
    this.date,
    this.profilePicture,
    this.studentName,
  });

  Widget _buildDetailRow(IconData iconData, String text, bool isEditButton) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: <Widget>[
              Icon(iconData, color: AppColors.blueGrey, size: 25.0),
              SizedBox(width: DS.width * 0.07),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          if (isEditButton)
            GestureDetector(
              onTap: () {
                Get.to(ChangeMobileNumberScreen());
              },
              child: const Icon(Icons.edit, color: AppColors.blueGrey, size: 25.0),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");

    return Card(
      elevation: 2.0,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.all(20.0),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(13.0),
                ),
                child:
                    //profilePicture == null
                    //    ?
                    Image.memory(
                  profilePicture,
                  fit: BoxFit.contain,
                )
//                  : Image.asset(
//                      Images.personPlaceholder,
//                      scale: 1.5,
//                      width: DS.width * 0.4,
//                    ),
                ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: DS.width * 0.15),
            child: Text(
              studentName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            studentId,
            style: const TextStyle(
              color: AppColors.blueGrey,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 18.0),
          _buildDetailRow(Icons.mail_outline, email, false),
          const Divider(color: AppColors.blueGrey, height: 20),
          _buildDetailRow(Icons.phone, phoneNumber, true),
          const Divider(color: AppColors.blueGrey, height: 20),
          _buildDetailRow(Icons.date_range, dateFormat.format(date), false),
          const SizedBox(height: 18.0),
        ],
      ),
    );
  }
}

class AcademicInformation extends StatelessWidget {
  final String college;
  final String degree;
  final String specialization;
  final String englishProficiencyLevel;
  final String academicAdvisor;
  final double cgpa;
  final double englishScore;

  AcademicInformation({
    this.academicAdvisor,
    this.cgpa,
    this.college,
    this.degree,
    this.englishProficiencyLevel,
    this.englishScore,
    this.specialization,
  });

  Widget _buildDetailRow(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 7.0,
                )),
            width: 20,
            height: 20,
          ),
          SizedBox(width: DS.width * 0.07),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: description,
                  style: const TextStyle(color: AppColors.blueGrey),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.all(20.0),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: <Widget>[
            _buildDetailRow('College: ', college ?? ''),
            const SizedBox(height: 4.0),
            const Divider(color: AppColors.primary),
            _buildDetailRow('Degree: ', degree ?? ''),
            const SizedBox(height: 4.0),
            const Divider(color: AppColors.primary),
            _buildDetailRow('Specialization: ', specialization ?? ''),
            const SizedBox(height: 4.0),
            const Divider(color: AppColors.primary),
            _buildDetailRow('English Proficiency Level: ', englishProficiencyLevel + ' - ' + englishScore.toString() ?? ''),
            const SizedBox(height: 4.0),
            const Divider(color: AppColors.primary),
            _buildDetailRow('Academic Advisor: ', academicAdvisor ?? ''),
            const SizedBox(height: 4.0),
            const Divider(color: AppColors.primary),
            _buildDetailRow('CGPA: ', cgpa.toString() ?? ''),
          ],
        ),
      ),
    );
  }
}
