import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:lisbon_travel/models/exceptions/network_error.dart';

Response<T> convertDioBody<T>(
  Response<dynamic> response, {
  T Function(dynamic data)? dataConverter,
}) {
  try {
    return Response<T>(
      data: dataConverter != null
          ? dataConverter.call(response.data)
          : response.data,
      headers: response.headers,
      isRedirect: response.isRedirect,
      requestOptions: response.requestOptions,
      redirects: response.redirects,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  } catch (error, stackTrace) {
    throw DioError(
      requestOptions: response.requestOptions,
      response: response,
      type: DioErrorType.other,
      error: error,
    )..stackTrace = stackTrace;
  }
}

/// A callback that returns a Dio response, presumably from a Dio method
/// it has called which performs an HTTP request, such as `dio.get()`,
/// `dio.post()`, etc.
typedef HttpLibraryMethod<T> = Future<Response<T>> Function();

Future<Either<NetworkError, Response<T>>> mapApiException<T>({
  required HttpLibraryMethod<T> method,
}) async {
  try {
    return Right(await method());
  } on DioError catch (exception) {
    switch (exception.type) {
      case DioErrorType.cancel:
        return Left(
          NetworkError(
            type: NetworkErrorType.canceled,
            originalException: exception,
          ),
        );
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return Left(
          NetworkError(
            type: NetworkErrorType.timedOut,
            originalException: exception,
          ),
        );
      case DioErrorType.response:
        // For DioErrorType.response, we are guaranteed to have a
        // response object present on the exception.
        final response = exception.response;
        if (response == null) {
          return Left(
            NetworkError(
              type: NetworkErrorType.responseError,
              statusCode: response?.statusCode,
              originalException: exception,
            ),
          );
        } else {
          return Left(
            NetworkError(
              type: NetworkErrorType.responseError,
              statusCode: response.statusCode,
              responseData: response.data,
              originalException: exception,
            ),
          );
        }
      case DioErrorType.other:
        return Left(
          NetworkError(
            type: NetworkErrorType.other,
            originalException: exception,
          ),
        );
    }
  } catch (e) {
    if (e is Exception) {
      return Left(
        NetworkError(
          type: NetworkErrorType.other,
          originalException: e,
        ),
      );
    } else {
      return const Left(
        NetworkError(
          type: NetworkErrorType.other,
        ),
      );
    }
  }
}
