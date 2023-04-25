import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_autocomplete_prediction.freezed.dart';

part 'place_autocomplete_prediction.g.dart';

@freezed
class PlaceAutocompletePrediction with _$PlaceAutocompletePrediction {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PlaceAutocompletePrediction({
    required String description,
    String? placeId,
    List<String>? types,
    int? distanceMeters,
  }) = _PlaceAutocompletePrediction;

  factory PlaceAutocompletePrediction.fromJson(Map<String, dynamic> json) =>
      _$PlaceAutocompletePredictionFromJson(json);
}
