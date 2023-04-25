import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_error.freezed.dart';

@freezed
class NetworkError with _$NetworkError {
  const factory NetworkError({
    required NetworkErrorType type,
    int? statusCode,
    Exception? originalException,
    dynamic responseData,
  }) = _NetworkError;
}

enum NetworkErrorType {
  /// A request cancellation is responsible for the exception.
  canceled,

  /// A timeout error is responsible for the exception.
  timedOut,

  /// A response error is responsible for the exception.
  responseError,
  other,
}
