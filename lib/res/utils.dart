import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences prefs;
  static Dio dio;

  Utils.initialize() {
    SharedPreferences.getInstance().then((value) => prefs = value);
    BaseOptions options = BaseOptions(
      baseUrl: "http://integrations.aue.ae/stdsvc/Student/",
      headers: {"Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw"},
      responseType: ResponseType.json,
      connectTimeout: 30000,
      sendTimeout: 30000,
      receiveTimeout: 30000,
    );

    dio = Dio(options);

    dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: "http://integrations.aue.ae/stdsvc/Student/"),
      ).interceptor,
    );
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
