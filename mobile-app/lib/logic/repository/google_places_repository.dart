import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/api_service/dio_converter.dart';
import 'package:lisbon_travel/api_service/google_places_api.dart';
import 'package:lisbon_travel/constants/constants.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/models/exceptions/network_error.dart';
import 'package:lisbon_travel/models/requests/place_autocomplete_request.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:uuid/v4.dart';

abstract class GooglePlacesRepository {
  Future<Either<NetworkError, Response<List<PlaceAutocompletePrediction>>>>
      getPlaceAutocomplete(
    String input,
  );
}

class GooglePlacesRemoteRepository extends GooglePlacesRepository {
  final LocationService _locationService;
  final String _uuid = const UuidV4().generate();

  GooglePlacesRemoteRepository({
    required LocationService locationService,
  }) : _locationService = locationService;

  Dio get dio => GetIt.I.get<Dio>(instanceName: kGooglePlacesDioInstanceName);

  @override
  Future<Either<NetworkError, Response<List<PlaceAutocompletePrediction>>>>
      getPlaceAutocomplete(
    String input,
  ) async {
    // get user location if possible
    Position? location;
    if (_locationService.position != null) {
      location = _locationService.position;
    } else {
      final locationReq = await _locationService.forceRequestLocation();
      if (locationReq.isRight) {
        location = locationReq.right;
      }
    }

    // get user country code if possible
    String? countryCode;
    if (_locationService.placemark != null) {
      countryCode = _locationService.placemark?.isoCountryCode;
    } else {
      final placemark = await _locationService.getCurrentPlace();
      countryCode = placemark?.isoCountryCode;
    }

    // request predictions
    return mapApiException<List<PlaceAutocompletePrediction>>(
      method: () => GooglePlacesApi(dio).getPlaceAutocomplete(
        PlaceAutocompleteRequest(
          input: input,
          location: location?.toLatLng(),
          components: countryCode != null ? [countryCode] : null,
          sessionToken: _uuid,
        ),
      ),
    );
  }
}
