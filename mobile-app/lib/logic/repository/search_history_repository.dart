import 'dart:convert';

import 'package:lisbon_travel/logic/service/shared_pref_service.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

abstract class SearchHistoryRepository {
  List<PlaceAutocompletePrediction> getAll();

  PlaceAutocompletePrediction? getOne(String placeId);

  Future<bool> insert(PlaceAutocompletePrediction prediction);

  Future<void> clear();
}

class SearchHistoryLocalRepository extends SearchHistoryRepository {
  static const String _storageKey = 'RECENT_SEARCHES';
  static const int _maxSize = 5;
  final SharedPrefService _pref;

  SearchHistoryLocalRepository({
    required SharedPrefService preferencesService,
  }) : _pref = preferencesService;

  @override
  Future<void> clear() {
    return _pref.removePrefKey(_storageKey);
  }

  @override
  List<PlaceAutocompletePrediction> getAll() {
    final searchHistoryJson = _pref.getPrefString(_storageKey);
    if (searchHistoryJson.isEmpty) {
      return [];
    } else {
      return (json.decode(searchHistoryJson) as List)
          .map((e) => PlaceAutocompletePrediction.fromJson(e))
          .toList();
    }
  }

  @override
  PlaceAutocompletePrediction? getOne(String placeId) {
    return getAll().firstWhereOrNull((element) => element.placeId == placeId);
  }

  @override
  Future<bool> insert(PlaceAutocompletePrediction prediction) async {
    final searchHistory = getAll();
    if (!searchHistory.contains(prediction)) {
      searchHistory.insert(0, prediction);
      if (searchHistory.length > _maxSize) {
        searchHistory.removeLast();
      }
      await _pref.setPrefValue(
        _storageKey,
        json.encode(searchHistory),
      );
      return true;
    } else {
      return false;
    }
  }
}
