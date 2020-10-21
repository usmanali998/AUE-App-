// import 'package:aue/dialogue_setup/alert_request.dart';
// import 'package:aue/dialogue_setup/dialogue_service.dart';
// import 'package:aue/res/platform_dialogue.dart';
// import 'package:aue/services/get_it.dart';
// import 'package:flutter/material.dart';

// class DialogManager extends StatefulWidget {
//   final Widget child;

//   const DialogManager({Key key, this.child}) : super(key: key);
//   @override
//   _DialogManagerState createState() => _DialogManagerState();
// }

// class _DialogManagerState extends State<DialogManager> {
//   DialogService dialogService = locator<DialogService>();

//   @override
//   void initState() {
//     super.initState();
//     dialogService.registerDialogListener(_showDialogue);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }

//   _showDialogue(AlertRequest request) {
//     showPlatformDialogue(
//       context,
//       title: request.title,
//       content: request.content,
//       action1Text: request.action1Text ?? "OK",
//       action2Text: request.action2Text ?? "OK",
//       service: dialogService,
//       action1OnTap:
//           request.action1Result != null ? request.action1Result : null,
//       action2OnTap:
//           request.action2Result != null ? request.action2Result : null,
//     );
//   }
// }
