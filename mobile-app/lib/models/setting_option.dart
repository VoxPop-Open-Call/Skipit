import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_option.freezed.dart';

part 'setting_option.g.dart';

@freezed
class SettingOption with _$SettingOption {
  const factory SettingOption({
    @Default(false) bool showAccessibility,
    @Default(false) bool filterBasedOnAccessibility,
  }) = _SettingOption;

  factory SettingOption.fromJson(Map<String, dynamic> json) =>
      _$SettingOptionFromJson(json);
}
