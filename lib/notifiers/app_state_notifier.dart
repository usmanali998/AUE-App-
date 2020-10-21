import 'dart:async';
import 'dart:convert';
import 'package:aue/model/class_update.dart';
import 'package:aue/model/class_discussion_model.dart';
import 'package:aue/model/course.dart';
import 'package:aue/model/sections.dart';
import 'package:aue/model/sent_otp_model.dart';
import 'package:aue/model/user.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/notifiers/base_notifier.dart';
import 'package:aue/pages/onboarding/onboarding.dart';
import 'package:aue/pages/tabs_view/tabs_view.dart';
import 'package:aue/res/utils.dart';
import 'package:aue/services/repository.dart';
import 'package:get/get.dart';

class AppStateNotifier extends BaseNotifier {
  AuthNotifier authNotifier;

  Course selectedCourse;

  Section selectedSection;

  ClassDiscussionModel selectedDiscussion;

  User user;

  SentOtpModel sentOtpModel;

  bool isOTPVerified = false;

  List<ClassUpdate> classUpdates;

  update(AuthNotifier notifier) {
    authNotifier = notifier;
  }

  AppStateNotifier() {
    handleStartupLogic();
  }

  Future<void> handleStartupLogic() async {
    Timer(Duration(seconds: 2), () {
      final userString = Utils.prefs.getString("user");
      if (userString == null) {
        Get.offAll(OnboardingPage());
      } else {
        final user = User.fromJson(jsonDecode(userString));
        authNotifier.user = user;
        Get.offAll(TabsView());
      }
    });
  }

  Future<void> getStudentInformation(String studentId) async {
    setViewState(ViewState.Busy);
    try {
      User user = await Repository.getStudentInformation(studentId);
      this.user = user;
    } catch (error) {
      print("Error: $error");
    } finally {
      setViewState(ViewState.Idle);
    }
  }

  Future<bool> sendOTP(
      String studentId, String phoneNumber, int numOfDigits) async {
    setViewState(ViewState.Busy);
    String response;

    try {
      response = await Repository.sendOTP(studentId, phoneNumber, numOfDigits);
    } catch (error) {
      print("Error: $error");
    } finally {
      setViewState(ViewState.Idle);
    }

    return response != null;
  }

  Future<void> changeStudentPassword(
      String studentId, String newPassword) async {
    setViewState(ViewState.Busy);
    try {
      String response =
          await Repository.changeStudentPassword(studentId, newPassword);
      Get.snackbar("Password Changed Successfully", response);
    } catch (error) {
      print("Error: $error");
    } finally {
      setViewState(ViewState.Idle);
    }
  }

//<<<<<<< HEAD
  Future<void> changePhoneNumber(String studentId, String newPhoneNumber) async {
    setViewState(ViewState.Busy);
    try {
      String response = await Repository.changePhoneNumber(studentId, newPhoneNumber);
      Get.snackbar("Phone Number Changed", response);
    } catch (error) {
      print("Error: $error");
    } finally {
      setViewState(ViewState.Idle);
    }
  }

  Future<void> verifyOTPAndUpdateStatus(String studentId, String sentOTP) async {
//=======
//  Future<void> verifyOTPAndUpdateStatus(
//      String studentId, String sentOTP) async {
//>>>>>>> a26cb10c327e0b9fe51e9eacad8968c183335499
    setViewState(ViewState.Busy);
    try {
      this.sentOtpModel = await Repository.getSentOTPForVerification(studentId);

      if (sentOTP == this.sentOtpModel.table[0].sentOtp) {
        await Repository.updateSentOTPStatus(studentId, sentOTP, true);
        this.isOTPVerified = true;
      } else {
        await Repository.updateSentOTPStatus(studentId, sentOTP, false);
        this.isOTPVerified = false;
      }
    } catch (error) {
      this.isOTPVerified = false;
      print("Error: $error");
    } finally {
      setViewState(ViewState.Idle);
    }
  }

  Future<void> getClassUpdates(String studentId) async {
    setViewState(ViewState.Busy);

    try {
      this.classUpdates = await Repository.getClassUpdates(studentId);
    } catch (error) {
      print("Error: $error");
    } finally {
      setViewState(ViewState.Idle);
    }
  }
}
