// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';

// import 'package:aue/dialogue_setup/alert_request.dart';

// class DialogService {
//   Function(AlertRequest) _showDialogListener;
//   Completer<bool> _dialogCompleter;

//   void registerDialogListener(Function(AlertRequest) showDialogListener) {
//     _showDialogListener = showDialogListener;
//   }

//   Future<bool> showDialogue({
//     @required String title,
//     Widget content,
//     String action1Text,
//     bool action1Result,
//     String action2Text,
//     bool action2Result,
//   }) {
//     _dialogCompleter = Completer<bool>();
//     _showDialogListener(
//       AlertRequest(
//         title: title,
//         content: content,
//         action1Result: action1Result,
//         action1Text: action1Text,
//         action2Result: action2Result,
//         action2Text: action2Text,
//       ),
//     );
//     return _dialogCompleter.future;
//   }

//   void dialogueComplete(bool result) {
//     _dialogCompleter.complete(result);
//     _dialogCompleter = null;
//   }
// }
