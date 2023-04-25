import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';

class ToastManager {
  static const _defaultDuration = Duration(milliseconds: 2500);
  GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;

  ToastManager({GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey})
      : _scaffoldMessengerKey = scaffoldMessengerKey;

  initialize(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
    _scaffoldMessengerKey = scaffoldMessengerKey;
  }

  void success(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: AppColors.successToast,
      behavior: SnackBarBehavior.floating,
      duration: _defaultDuration,
    );
    _scaffoldMessengerKey?.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void info(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: _defaultDuration,
    );
    _scaffoldMessengerKey?.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void error(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: AppColors.errorToast,
      behavior: SnackBarBehavior.floating,
      duration: _defaultDuration,
    );
    _scaffoldMessengerKey?.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
