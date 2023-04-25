import 'package:lisbon_travel/logic/service/shared_pref_service.dart';
import 'package:lisbon_travel/models/setting_option.dart';

class SettingsService {
  final SharedPrefService _sharedPreferences;
  static const String _kPrefKey = 'settings-json';
  late SettingOption _options;

  SettingsService({required SharedPrefService sharedPreferences})
      : _sharedPreferences = sharedPreferences {
    _options = SettingOption.fromJson(sharedPreferences.getPrefJSON(_kPrefKey));
  }

  SettingOption get options => _options;

  Future<void> updateOptions(SettingOption option) async {
    if (_options != option) {
      _options = option;
      await _sharedPreferences.setPrefValue(_kPrefKey, _options.toJson());
    }
  }
}
