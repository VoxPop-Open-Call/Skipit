part of 'trip_bloc.dart';

@freezed
class TripEvent with _$TripEvent {
  const factory TripEvent.clearPoints({
    @Default(false) bool origin,
    @Default(false) bool destination,
  }) = _ClearPoints;

  const factory TripEvent.setPoint({
    PlaceAutocompletePrediction? origin,
    PlaceAutocompletePrediction? destination,
    DateTime? dateTime,
    TripDateType? tripDateType,
  }) = _SetPoint;

  const factory TripEvent.startTrip({
    required DirectionsRoute route,
    required TravelMode travelMode,
    List<TransitOption>? transitOption,
  }) = _StartTrip;

  const factory TripEvent.endTrip() = _EndTrip;

  const factory TripEvent.navigationNextStep() = _NavigationNextStep;
}
