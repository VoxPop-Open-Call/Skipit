import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

part 'trip_routes_model.freezed.dart';

@freezed
class TripRouteModel with _$TripRouteModel {
  const factory TripRouteModel({
    List<DirectionsRoute>? transitRoutes,
    List<DirectionsRoute>? walkingRoutes,
    List<DirectionsRoute>? cyclingRoutes,
    List<TransitOption>? transitOption,
    String? error,
  }) = _TripRouteModel;
}

extension TripRouteModelX on TripRouteModel {
  TripRouteModel get filteredCopy {
    // if there is no route |or| we don't have any route accessibility data,
    // there is nothing to filter and we return the same thing
    // whether it's null or empty!
    if (transitRoutes?.isNotEmpty != true &&
        transitOption?.isNotEmpty != true) {
      return this;
    }

    return copyWith(
      transitRoutes: transitRoutes?.where((route) {
        final stations = route.stations;
        if (stations.isNotEmpty) {
          for (final station in stations) {
            // if one station doesn't have at least 3 accessibility
            // the whole route is not accessible
            final accessibilities =
                transitOption?.findByTransitTypeTuple(station)?.accessibilities;
            if (accessibilities == null || accessibilities.length < 3) {
              return false;
            }
          }

          // all stations had some sort of accessibility
          // so the whole route is accessible
          return true;
        } else {
          // there is no station on this route, so everything is accessible.
          return true;
        }
      }).toList(),
    );
  }
}
