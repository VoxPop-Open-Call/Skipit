import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_travel/models/convertors/lat_lng_convertor.dart';

part 'place_autocomplete_request.freezed.dart';

part 'place_autocomplete_request.g.dart';

@freezed
class PlaceAutocompleteRequest with _$PlaceAutocompleteRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PlaceAutocompleteRequest({
    required String input,
    @Default('en') String language,
    @Default(50000) int radius,
    @_ComponentsConverter() List<String>? components,
    @LatLngConvertor() LatLng? location,
    @JsonKey(name: 'sessiontoken') String? sessionToken,
  }) = _PlaceAutocompleteRequest;

  factory PlaceAutocompleteRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceAutocompleteRequestFromJson(json);
}

class _ComponentsConverter implements JsonConverter<List<String>, String> {
  const _ComponentsConverter();

  @override
  List<String> fromJson(String json) {
    return json.split('|').map((e) => e.split(':')[1]).toList();
  }

  @override
  String toJson(List<String> data) {
    return data.map((e) => 'country:$e').join('|');
  }
}
