import 'package:conversion_calculator/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  DioClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    if (kDebugMode) {
      dio.interceptors.add(_RequestResponseLogInterceptor());
    }
  }

  final Dio dio;

  Future<Response<T>> request<T>(
    String path, {
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final normalized =
        path.isEmpty ? '' : (path.startsWith('/') ? path : '/$path');

    final merged = (options ?? Options()).copyWith(method: method);

    return dio.request<T>(
      normalized,
      data: data,
      queryParameters: queryParameters,
      options: merged,
    );
  }
}

/// Registra request, response y errores de red / HTTP.
class _RequestResponseLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.d(
      '[HTTP] --> ${options.method} ${options.uri}\n'
      'headers: ${options.headers}\n'
      'query: ${options.queryParameters}\n'
      'data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    appLogger.i(
      '[HTTP] <-- ${response.statusCode} ${response.requestOptions.uri}\n'
      'data: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.e(
      '[HTTP] xx ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'type: ${err.type}\n'
      'message: ${err.message}\n'
      'status: ${err.response?.statusCode}\n'
      'data: ${err.response?.data}',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}
