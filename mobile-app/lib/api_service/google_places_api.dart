import 'package:dio/dio.dart';
import 'package:lisbon_travel/api_service/dio_converter.dart';
import 'package:lisbon_travel/models/requests/place_autocomplete_request.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';

class GooglePlacesApi {
  final Dio _dio;

  GooglePlacesApi(Dio dio) : _dio = dio;

  Future<Response<List<PlaceAutocompletePrediction>>> getPlaceAutocomplete(
    PlaceAutocompleteRequest placeAutocompleteRequest,
  ) async {
    final request = await _dio.get(
      '/autocomplete/json',
      queryParameters: placeAutocompleteRequest.toJson(),
    );

    return convertDioBody<List<PlaceAutocompletePrediction>>(
      request,
      dataConverter: (data) => data['predictions'] is List
          ? (data['predictions'] as List)
              .map((e) => PlaceAutocompletePrediction.fromJson(e))
              .toList(growable: false)
          : [],
    );
  }
}
