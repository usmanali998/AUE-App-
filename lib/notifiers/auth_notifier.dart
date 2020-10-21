import 'dart:convert';
import 'package:aue/interceptors/login_interceptor.dart';
import 'package:aue/model/user.dart';
import 'package:aue/notifiers/base_notifier.dart';
import 'package:aue/pages/auth/login.dart';
import 'package:aue/pages/tabs_view/tabs_view.dart';
import 'package:aue/res/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../res/utils.dart';

class AuthNotifier extends BaseNotifier {
  AuthNotifier() {
    // BaseOptions options = BaseOptions(
    //   baseUrl: "http://integrations.aue.ae/stdsvc/Student/",
    //   headers: {"Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw"},
    //   responseType: ResponseType.json,
    //   connectTimeout: 30000,
    //   sendTimeout: 30000,
    //   receiveTimeout: 30000,
    // );
    dio = Utils.dio;

    dio.interceptors.addAll([
      LoginInterceptor(),
      // LogInterceptor(
      //   error: true,
      //   // responseBody: true,
      // ),
    ]);
  }

  Dio dio;
  User user;

  Future<void> login(String studentId, String password, bool remember) async {
    setViewState(ViewState.Busy);
    final parameters = {
      "StudentID": studentId,
      "Password": password,
    };
    try {
      user = (await dio.get("Login", queryParameters: parameters)).data;
      print(user);
      if (remember) {
        print("SETTING TO PREFERENCES");
        await Utils.prefs.setString("user", jsonEncode(user.toJson()));
        setViewState(ViewState.Idle);
        Get.offAll(TabsView());
      } else {
        setViewState(ViewState.Idle);
        Get.offAll(TabsView());
      }
    } catch (e) {
      print("ERROR $e");
    } finally {
      setViewState(ViewState.Idle);
    }
  }

  Future logout() async {
    setViewState(ViewState.Busy);
    await Utils.prefs.remove("user");
    setViewState(ViewState.Idle);
    Get.offAll(LoginPage());
  }
}
