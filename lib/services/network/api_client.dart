import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  Dio getDioClient() {
    late String baseUrl = '';

    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 75),
      receiveTimeout: const Duration(seconds: 75),
    );

    final dio = Dio(options);
    dio.options.contentType = Headers.jsonContentType;
    dio.options.responseType = ResponseType.json;
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        // ignore: avoid_print
        logPrint: (log) => print(log),
      ));
    }
    return dio;
  }
}
