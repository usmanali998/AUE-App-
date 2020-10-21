import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../res/platform_dialogue.dart';

class LoginInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    if (response.statusCode == HttpStatus.ok &&
        response.request.path == "Login") {
      response.data = User.fromJson(response.data);
      return super.onResponse(response);
    }

    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    //Invalid Credentials
    if (err.type == DioErrorType.RESPONSE) {
      final message = err.response.data.toString();
      showPlatformDialogue(
        title: message,
        content: Text(err.message.toString()),
      );
    }

    if (err.type == DioErrorType.CONNECT_TIMEOUT) {
      showPlatformDialogue(
        title: "Connection Timed out",
        content: Text(err.message.toString()),
      );
    }

    if (err.type == DioErrorType.RECEIVE_TIMEOUT) {
      showPlatformDialogue(
        title: "Recieving Timed out",
        content: Text(err.message.toString()),
      );
    }

    if (err.type == DioErrorType.SEND_TIMEOUT) {
      showPlatformDialogue(
        title: "Send Timed out",
        content: Text(err.message.toString()),
      );
    }
    if (err.type == DioErrorType.SEND_TIMEOUT) {
      showPlatformDialogue(
        title: "Send Timed out",
        content: Text(err.message.toString()),
      );
    }

    //No Internet Connection
    if (err.type == DioErrorType.DEFAULT) {
      if (err.message.contains("SocketException")) {
        showPlatformDialogue(
          title: "No Internet Connection",
          content: Text("Please check your connection and try again."),
        );
      } else {
        showPlatformDialogue(
          title: "Unknown Error",
          content: Text(err.message),
        );
      }
    }

    return super.onError(err);
  }
}
