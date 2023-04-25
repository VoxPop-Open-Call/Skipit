part of 'map_bloc.dart';

@freezed
class MapEvent with _$MapEvent {
  const factory MapEvent.started() = _Started;

  const factory MapEvent.setController(GoogleMapController controller) =
      _SetController;

  const factory MapEvent.setLocation(LatLng location, {double? zoom}) =
      _SetLocation;

  const factory MapEvent.showRoute(DirectionsRoute route) = _ShowRoute;

  const factory MapEvent.clearRoute() = _ClearRoute;
}
