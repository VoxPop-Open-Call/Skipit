import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';

final $styles = AppStyle();

class AppStyle {
  /// Text styles
  /// ignore: library_private_types_in_public_api
  // late _Text text = _Text();

  /// Button styles
  /// ignore: library_private_types_in_public_api
  late _ButtonStyle button = _ButtonStyle();
}

// @immutable
// class _Text {}

class _ButtonStyle {
  final ButtonStyle primaryTextButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.primaryButton,
    disabledForegroundColor: Colors.grey.shade50,
    disabledBackgroundColor: AppColors.primaryButtonDisabled,
    minimumSize: const Size(200, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  late final fabGrey = ElevatedButton.styleFrom(
    elevation: 1,
    backgroundColor: AppColors.grey100,
    foregroundColor: Colors.red[600],
    padding: EdgeInsets.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
