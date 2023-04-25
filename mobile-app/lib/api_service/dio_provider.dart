import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum AccessTokenProviderType {
  header,
  query,
}

Dio dio({
  required String baseUrl,
  String? authAccessToken,
  AccessTokenProviderType accessTokenProviderType =
      AccessTokenProviderType.header,
  String Function(Dio dio)? requestNewAccessToken,
}) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      contentType: ContentType.json.value,
    ),
  );

  if (!kReleaseMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        if (authAccessToken != null && authAccessToken != '') {
          switch (accessTokenProviderType) {
            case AccessTokenProviderType.header:
              request.headers['Authorization'] = 'Bearer $authAccessToken';
              break;
            case AccessTokenProviderType.query:
              request.queryParameters['key'] = authAccessToken;
              break;
          }
        }
        return handler.next(request);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            requestNewAccessToken != null) {
          // request new token
          final newAccessToken = requestNewAccessToken.call(dio);

          // set bearer
          error.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';

          // create request with new access token
          final opts = Options(
            method: error.requestOptions.method,
            headers: error.requestOptions.headers,
          );
          final cloneReq = await dio.request(
            error.requestOptions.path,
            options: opts,
            data: error.requestOptions.data,
            queryParameters: error.requestOptions.queryParameters,
          );

          return handler.resolve(cloneReq);
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
}
