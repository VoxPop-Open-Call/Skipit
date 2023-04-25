import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = lightBlue;
  static const Color backgroundGray = grey100;
  static const Color textGrey = grey300;
  static const Color textBlack = black;
  static const Color textWhite = white;
  static const Color primaryButton = lightBlue;
  static const Color primaryButtonDisabled = grey300;

  static const Color sliderDotActive = Color(0xFF484545);
  static const Color sliderDotInActive = Color(0xFFD9D9D9);

  // toast colors
  static const errorToast = Color(0xFFDB4343);
  static const successToast = Color(0xFF388E3C);

  // === Color names ===
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightBlue = Color(0xFF006DF6);
  static const Color cyan = Color(0xFF7EC5C4);
  static const Color grey100 = Color(0xFFF7F7F7);
  static const Color grey200 = Color(0xFFD1D1D1);
  static const Color grey300 = Color(0xFFB4B4B4);

  static toTheme() {
    return ThemeData(
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        background: white,
      ),
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        iconTheme: IconThemeData(color: black),
        foregroundColor: black,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusColor: textGrey,
        fillColor: backgroundGray,
        filled: true,
        border: OutlineInputBorder(),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryButton,
        height: 42,
      ),
      dialogTheme: DialogTheme(

      ),
    );
  }
}
