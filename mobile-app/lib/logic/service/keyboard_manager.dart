import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardManager {
  bool isKeyboardVisible(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom > 0;

  void dismissKeyboard() =>
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
}
