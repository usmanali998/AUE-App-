import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';

class CustomErrorWidget extends StatelessWidget {
  final DioError err;
  final bool fullSize;
  final VoidCallback onRetryTap;
  const CustomErrorWidget({
    Key key,
    @required this.err,
    this.fullSize = false,
    this.onRetryTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (err.type == DioErrorType.RESPONSE) {
      final message = err.response.data.toString();

      return buildErrorWidget(text: message);
    }

    if (err.type == DioErrorType.CONNECT_TIMEOUT) {
      return buildErrorWidget(text: "Connection Timed out");
    }

    if (err.type == DioErrorType.RECEIVE_TIMEOUT) {
      return buildErrorWidget(text: "Receiving Timed out");
    }

    if (err.type == DioErrorType.SEND_TIMEOUT) {
      return buildErrorWidget(text: "Send Timed out");
    }

    //No Internet Connection
    if (err.type == DioErrorType.DEFAULT) {
      if (err.message.contains("SocketException") || err.message.contains("HttpException")) {
        return buildErrorWidget(text: "No Internet Connection");
      } else {
        return buildErrorWidget(text: "Unknown Error");
      }
    }

    return buildErrorWidget(text: "Unknown Error");
  }

  Widget buildErrorWidget({IconData icon, String text}) {
    return Container(
      width: DS.width,
      height: fullSize ? DS.height * 0.9 : DS.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: false,
            child: Icon(
              icon ?? Icons.error_outline,
              color: Colors.red,
              size: DS.setSP(80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16),
            child: Text(
              text ?? "Error",
              style: TextStyle(
                color: Colors.black54,
                fontSize: DS.setSP(18),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: PrimaryButton(
              text: "Retry",
              onTap: onRetryTap,
            ),
          ),
        ],
      ),
    );
  }
}
