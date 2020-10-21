import 'package:flutter/foundation.dart';

enum ViewState { Idle, Busy }

class BaseNotifier with ChangeNotifier {
  ViewState viewState = ViewState.Idle;

  setViewState(ViewState state) {
    print("CHANING VIEWSTATE FROM $viewState TO $state");
    viewState = state;
    notifyListeners();
  }
}
