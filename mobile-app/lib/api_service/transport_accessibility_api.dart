import 'package:dio/dio.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/models/responses/transport_map_response.dart';

import 'dio_converter.dart';

class TransportAccessibilityApi {
  final Dio _dio;

  TransportAccessibilityApi(Dio dio) : _dio = dio;

  Future<Response<List<TransitOption>>> getTransitOptions({
    int skip = 0,
    int take = 10,
    String? nameEquals,
    List<String>? nameIn,
    String? nameContains,
    bool nameCaseInsensitive = false,
  }) async {
    final request = await _dio.get(
      '/transitOptions',
      queryParameters: {
        'skip': skip,
        'take': take,
        if (nameEquals != null) 'where[name][equals]': nameEquals,
        if (nameIn != null) 'where[name][in]': nameIn,
        if (nameContains != null) 'where[name][contains]': nameContains,
        if (nameCaseInsensitive) 'where[name][mode]': 'insensitive',
      },
    );

    return convertDioBody<List<TransitOption>>(
      request,
      dataConverter: (data) => data is List && data.isNotEmpty
          ? data.map((e) => TransitOption.fromJson(e)).toList(growable: false)
          : [],
    );
  }

  Future<Response<TransitOption>> getTransitOptionWithId(String id) async {
    final request = await _dio.get(
      '/transitOptions/$id',
    );

    return convertDioBody<TransitOption>(
      request,
      dataConverter: (data) => TransitOption.fromJson(data),
    );
  }

  Future<Response<List<TransportMapResponse>>> getTransportMaps() async {
    final request = await _dio.get(
      '/transportMaps',
    );

    return convertDioBody<List<TransportMapResponse>>(
      request,
      dataConverter: (data) => data is List && data.isNotEmpty
          ? data
              .map((e) => TransportMapResponse.fromJson(e))
              .toList(growable: false)
          : [],
    );
  }

  Future<Response<TransportMapResponse>> getTransportMapWithId(
      String id) async {
    final request = await _dio.get(
      '/transportMaps/$id',
    );

    return convertDioBody<TransportMapResponse>(
      request,
      dataConverter: (data) => TransportMapResponse.fromJson(data),
    );
  }
}
