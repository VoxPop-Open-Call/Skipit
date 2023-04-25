import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLngConvertor implements JsonConverter<LatLng, String> {
  const LatLngConvertor();

  @override
  LatLng fromJson(String json) {
    final latLng = json.split(',');
    return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
  }

  @override
  String toJson(LatLng data) {
    return '${data.latitude},${data.longitude}';
  }
}
