import 'package:flutter/material.dart';

extension LoadingIndicator on AsyncSnapshot {
  bool get isLoading {
    return this.connectionState == ConnectionState.waiting;
  }
}
