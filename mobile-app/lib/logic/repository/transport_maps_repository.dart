import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/api_service/dio_converter.dart';
import 'package:lisbon_travel/api_service/transport_accessibility_api.dart';
import 'package:lisbon_travel/constants/constants.dart';
import 'package:lisbon_travel/models/exceptions/network_error.dart';
import 'package:lisbon_travel/models/responses/transport_map_response.dart';

abstract class TransportMapsRepository {
  Future<Either<NetworkError, Response<TransportMapResponse>>> getWithId(
      String id);

  Future<Either<NetworkError, Response<List<TransportMapResponse>>>> getAll();
}

class TransportMapsRemoteRepository extends TransportMapsRepository {
  TransportMapsRemoteRepository();

  Dio get dio =>
      GetIt.I.get<Dio>(instanceName: kTransportAccessibilityDioInstanceName);

  @override
  Future<Either<NetworkError, Response<TransportMapResponse>>> getWithId(
    String id,
  ) async {
    return mapApiException<TransportMapResponse>(
      method: () => TransportAccessibilityApi(dio).getTransportMapWithId(id),
    );
  }

  @override
  Future<Either<NetworkError, Response<List<TransportMapResponse>>>>
      getAll() async {
    return mapApiException<List<TransportMapResponse>>(
      method: () => TransportAccessibilityApi(dio).getTransportMaps(),
    );
  }
}
