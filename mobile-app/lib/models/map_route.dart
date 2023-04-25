import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_route.freezed.dart';

@freezed
class MapRoute with _$MapRoute {
  const factory MapRoute({
    List<String>? steps,
    List<String>? stepDurations,
    Set<Marker>? markers,
    Set<Polyline>? polyLines,
  }) = _MapRoute;
}
