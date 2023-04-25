import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension PositionExtension on Position {
  double distanceTo(Position other) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      other.latitude,
      other.longitude,
    );
  }

  double distanceToCoordinates(double otherLat, double otherLng) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      otherLat,
      otherLng,
    );
  }

  double bearingTo(Position other) {
    return Geolocator.bearingBetween(
      latitude,
      longitude,
      other.latitude,
      other.longitude,
    );
  }

  bool isSameLocation(Position other) {
    return latitude == other.latitude && longitude == other.longitude;
  }

  bool isNotSameLocation(Position other) {
    return !isSameLocation(other);
  }

  bool isSameLocationWithTolerance(Position other, double tolerance) {
    return distanceTo(other) <= tolerance;
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
