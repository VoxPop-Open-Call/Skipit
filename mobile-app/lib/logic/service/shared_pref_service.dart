import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPrefService({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  /// Add a value in SharedPref based on their type - Must be a String, int, bool, double, Map<String, dynamic> or StringList
  Future<bool> setPrefValue(
    String key,
    dynamic value, {
    bool print = false,
  }) async {
    if (print) {
      debugPrint('Shared pref Saved key:$key value $value');
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else if (value is Map<String, dynamic>) {
      return await sharedPreferences.setString(key, jsonEncode(value));
    } else if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    } else {
      throw ArgumentError(
        'Invalid value ${value.runtimeType} - Must be a String, int, bool, double, Map<String, dynamic> or StringList',
      );
    }
  }

  /// Returns List of Keys that matches with given Key
  List<String> getMatchingSharedPrefKeys(String key) {
    List<String> keys = [];
    sharedPreferences.getKeys().forEach((element) {
      if (element.contains(key)) {
        keys.add(element);
      }
    });
    return keys;
  }

  /// Returns a StringList if exists in SharedPref
  List<String>? getPrefStringList(String key, {bool print = false}) {
    final value = sharedPreferences.getStringList(key);
    if (print) {
      debugPrint('Shared pref get key:$key value:$value');
    }
    return value;
  }

  /// Returns a Bool if exists in SharedPref
  bool getPrefBool(
    String key, {
    bool defaultValue = false,
    bool print = false,
  }) {
    final value = sharedPreferences.getBool(key) ?? defaultValue;
    if (print) {
      debugPrint('Shared pref get key:$key value:$value');
    }
    return value;
  }

  /// Returns a Double if exists in SharedPref
  double getPrefDouble(
    String key, {
    double defaultValue = 0.0,
    bool print = false,
  }) {
    final value = sharedPreferences.getDouble(key) ?? defaultValue;
    if (print) {
      debugPrint('Shared pref get key:$key value:$value');
    }
    return value;
  }

  /// Returns a Int if exists in SharedPref
  int getPrefInt(String key, {int defaultValue = 0, bool print = false}) {
    final value = sharedPreferences.getInt(key) ?? defaultValue;
    if (print) {
      debugPrint('Shared pref get key:$key value:$value');
    }
    return value;
  }

  /// Returns a String if exists in SharedPref
  String getPrefString(
    String key, {
    String defaultValue = '',
    bool print = false,
  }) {
    final value = sharedPreferences.getString(key) ?? defaultValue;
    if (print) {
      debugPrint('Shared pref get key:$key value:$value');
    }
    return value;
  }

  /// Returns a JSON if exists in SharedPref
  Map<String, dynamic> getPrefJSON(
    String key, {
    Map<String, dynamic>? defaultValue,
    bool print = false,
  }) {
    if (sharedPreferences.containsKey(key)) {
      final value = jsonDecode(sharedPreferences.getString(key) ?? '')
          as Map<String, dynamic>;
      if (print) {
        debugPrint('Shared pref get key:$key value:$value');
      }
      return value;
    } else {
      if (print) {
        debugPrint('Shared pref get key:$key value:$defaultValue');
      }
      return defaultValue ?? <String, dynamic>{};
    }
  }

  /// remove key from SharedPref
  Future<bool> removePrefKey(String key) async =>
      await sharedPreferences.remove(key);

  /// clear SharedPref
  Future<bool> clearSharedPref() async => await sharedPreferences.clear();
}
