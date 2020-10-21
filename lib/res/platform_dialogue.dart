import 'dart:io';

import 'package:aue/notifiers/base_notifier.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showPlatformDialogue({
  @required String title,
  Widget content,
  String action1Text,
  bool action1OnTap,
  String action2Text,
  bool action2OnTap,
}) async {
  print('in showPlatformDialogue');
  return await Get.dialog(
    Material(
//      type: MaterialType.transparency,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.clear,
                color: Colors.white,
                size: 43.0,
              ),
            ),
            SizedBox(height: DS.height * 0.04),
            const Text(
              'Wrong username or password',
              style: const TextStyle(
                color: AppColors.lightText,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: DS.height * 0.07),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: PrimaryButton(
                        margin: const EdgeInsets.all(0.0),
                        text: 'Try Again',
                        viewState: ViewState.Idle,
                        onTap: () => Get.back(result: action1OnTap)),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 7,
                    child: MaterialButton(
                      elevation: 0,
                      highlightElevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(const Radius.circular(8)),
                        side: const BorderSide(color: Colors.black54, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      onPressed: () => Get.back(result: action1OnTap),
                      color: Colors.transparent,
                      child: Text(
                        'Change Password',
                        style: Theme.of(Get.context).textTheme.bodyText1.copyWith(
                          color: AppColors.blueGrey,
                          fontSize: DS.setSP(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
//  return await Get.dialog(
//    (Platform.isAndroid)
//        ? AlertDialog(
//            title: Text(title),
//            content: content,
//            actions: <Widget>[
//              if (action2Text != null && action2OnTap != null)
//                FlatButton(
//                  child: Text(action2Text),
//                  onPressed: () => Get.back(result: action2OnTap),
//                ),
//              FlatButton(
//                child: Text(action1Text ?? "OK"),
//                onPressed: () => Get.back(result: action1OnTap),
//              ),
//            ],
//          )
//        : CupertinoAlertDialog(
//            content: content,
//            title: Text(title),
//            actions: <Widget>[
//              if (action2Text != null && action2OnTap != null)
//                CupertinoDialogAction(
//                  child: Text(action2Text ?? "OK"),
//                  onPressed: () => Get.back(result: action2OnTap),
//                ),
//              CupertinoDialogAction(
//                child: Text(action1Text ?? "OK"),
//                onPressed: () => Get.back(result: action1OnTap),
//              ),
//            ],
//          ),
//  );
}
