part of 'trip_bloc.dart';

@freezed
class TripState with _$TripState {
  const factory TripState.initial() = _Initial;

  const factory TripState.pointUpdated({
    PlaceAutocompletePrediction? origin,
    PlaceAutocompletePrediction? destination,
    TripRouteModel? routes,
  }) = _PointUpdated;

  const factory TripState.loading() = _Loading;

  const factory TripState.navigation({
    @Default(0) int currentStepIndex,
    required DirectionsRoute route,
    required TravelMode travelMode,
    List<TransitOption>? transitOption,
  }) = _Navigation;
}

// ignore: library_private_types_in_public_api
extension NavigationMethods on _Navigation {
  List<DirectionsStep>? get steps => route.steps;

  DirectionsStep? get currentStep {
    if (steps == null || steps!.isEmpty) return null;

    if (currentStepIndex >= steps!.length || currentStepIndex < 0) {
      return null;
    }

    return steps![currentStepIndex];
  }
}
