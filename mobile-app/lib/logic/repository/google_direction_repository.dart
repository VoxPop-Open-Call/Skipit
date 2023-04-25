import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';
import 'package:lisbon_travel/models/trip_routes_model.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

abstract class GoogleDirectionRepository {
  Future<Either<String, List<DirectionsRoute>>> getRoute({
    PlaceAutocompletePrediction? origin,
    required PlaceAutocompletePrediction destination,
    required TravelMode travelMode,
    String language,
    bool alternatives,
    DateTime? departureTime,
    DateTime? arrivalTime,
  });

  Future<TripRouteModel> getAllModeRoutes({
    PlaceAutocompletePrediction? origin,
    required PlaceAutocompletePrediction destination,
    String language,
    DateTime? departureTime,
    DateTime? arrivalTime,
  });
}

class GoogleDirectionRemoteRepository extends GoogleDirectionRepository {
  final LocationService _locationService;
  final directionService = DirectionsService();

  GoogleDirectionRemoteRepository({
    required LocationService locationService,
  }) : _locationService = locationService;

  @override
  Future<Either<String, List<DirectionsRoute>>> getRoute({
    PlaceAutocompletePrediction? origin,
    required PlaceAutocompletePrediction destination,
    required TravelMode travelMode,
    String language = 'en',
    bool alternatives = false,
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) async {
    if (origin == null && _locationService.position == null) {
      await _locationService.forceRequestLocation();
      if (_locationService.position == null) {
        return const Left('Origin is not specified.');
      }
    }

    late Either<String, List<DirectionsRoute>> result;
    await directionService.route(
      DirectionsRequest(
        origin: origin != null
            ? 'place_id:${origin.placeId}'
            : '${_locationService.position!.latitude},${_locationService.position!.longitude}',
        destination: 'place_id:${destination.placeId}',
        travelMode: travelMode,
        language: language,
        alternatives: alternatives,
        transitOptions: TransitOptions(
          arrivalTime: arrivalTime,
          departureTime: departureTime,
        ),
      ),
      (DirectionsResult response, DirectionsStatus? status) {
        if (status == DirectionsStatus.ok) {
          final routes = response.routes;
          if (routes == null || routes.isEmpty) {
            result = Left(LocaleKeys.cError_noRoute.tr());
            return;
          }

          // remove routes with one walking step if it's transit mode
          // only if we have alternative
          if (travelMode == TravelMode.transit && routes.length > 1) {
            final onlyWalkRoutes = routes.where(
              (route) =>
                  route.steps?.length == 1 &&
                  route.steps?.firstOrNull?.travelMode == TravelMode.walking,
            );
            if (onlyWalkRoutes.isNotEmpty &&
                routes.length > onlyWalkRoutes.length) {
              routes.removeWhere(
                (route) =>
                    route.steps?.length == 1 &&
                    route.steps?.firstOrNull?.travelMode == TravelMode.walking,
              );
            }
          }

          // remove routes with no steps
          routes.removeWhere(
            (route) => route.steps == null || route.steps!.isEmpty,
          );

          result = Right(routes);
        } else {
          result = const Left('Error getting directions');
        }
      },
    );

    return result;
  }

  @override
  Future<TripRouteModel> getAllModeRoutes({
    PlaceAutocompletePrediction? origin,
    required PlaceAutocompletePrediction destination,
    String language = 'en',
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) async {
    final transitTrip = await getRoute(
      origin: origin,
      destination: destination,
      travelMode: TravelMode.transit,
      alternatives: true,
      language: language,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );
    final walkTrip = await getRoute(
      origin: origin,
      destination: destination,
      travelMode: TravelMode.walking,
      language: language,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );
    final cycleTrip = await getRoute(
      origin: origin,
      destination: destination,
      travelMode: TravelMode.bicycling,
      language: language,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );

    if (transitTrip.isLeft && walkTrip.isLeft && cycleTrip.isLeft) {
      return TripRouteModel(error: transitTrip.left);
    } else {
      return TripRouteModel(
        transitRoutes: transitTrip.fold((l) => null, (r) => r),
        walkingRoutes: walkTrip.fold((l) => null, (r) => r),
        cyclingRoutes: cycleTrip.fold((l) => null, (r) => r),
      );
    }
  }
}
