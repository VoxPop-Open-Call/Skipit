import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/api_service/dio_converter.dart';
import 'package:lisbon_travel/api_service/transport_accessibility_api.dart';
import 'package:lisbon_travel/constants/constants.dart';
import 'package:lisbon_travel/models/exceptions/network_error.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';

abstract class TransitOptionRepository {
  Future<Either<NetworkError, Response<TransitOption>>> getWithId(String id);

  Future<Either<NetworkError, Response<List<TransitOption>>>> getList({
    int skip,
    int take,
    String? nameEquals,
    List<String>? nameIn,
    String? nameContains,
    bool nameCaseInsensitive,
  });
}

class TransitOptionRemoteRepository extends TransitOptionRepository {
  TransitOptionRemoteRepository();

  Dio get dio =>
      GetIt.I.get<Dio>(instanceName: kTransportAccessibilityDioInstanceName);

  @override
  Future<Either<NetworkError, Response<TransitOption>>> getWithId(
    String id,
  ) async {
    return mapApiException<TransitOption>(
      method: () => TransportAccessibilityApi(dio).getTransitOptionWithId(id),
    );
  }

  @override
  Future<Either<NetworkError, Response<List<TransitOption>>>> getList({
    int skip = 0,
    int take = 10,
    String? nameEquals,
    List<String>? nameIn,
    String? nameContains,
    bool nameCaseInsensitive = false,
  }) async {
    return mapApiException<List<TransitOption>>(
      method: () => TransportAccessibilityApi(dio).getTransitOptions(
        skip: skip,
        take: take,
        nameEquals: nameEquals,
        nameIn: nameIn,
        nameContains: nameContains,
        nameCaseInsensitive: nameCaseInsensitive,
      ),
    );
  }
}
