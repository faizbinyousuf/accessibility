import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_test/services/network/http_types.dart';
import 'package:map_test/services/network/network_exception.dart';
import 'package:map_test/utils/constants.dart';

import 'api_client.dart';

class ApiHelper {
  late ApiClient apiClient;

  ApiHelper(this.apiClient);

  Future<dynamic> callApi(
      {required String service,
      required HttpRequestType requestType,
      String? url,
      Map<String, dynamic>? params,
      dynamic data}) async {
    Options options =
        Options(contentType: Headers.jsonContentType, method: requestType.name);

    final dio = apiClient.getDioClient();

    dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions reqOptions, RequestInterceptorHandler handler) async {
      return handler.next(reqOptions);
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      if (error.response == null) {
        return;
      }
      _returnResponse(error.response!);
    }));

    if (url == null) {
      dio.options.baseUrl = AppConstants.baseUrl;
    }

    try {
      final response = await dio.request(service,
          options: options, queryParameters: params, data: data);
      return _returnResponse(response);
    } on TimeoutException catch (e) {
      throw TimeOutException(e.message);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {}
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        Fluttertoast.showToast(msg: response.toString());
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        Fluttertoast.showToast(msg: response.toString());

        /// Handle user logout here, showing an message "Session Expired"
        ///
        throw UnauthorisedException(response.toString());
      case 404:
        Fluttertoast.showToast(msg: response.toString());

        throw BadRequestException('Not found');
      case 500:
        Fluttertoast.showToast(
            msg:
                "${response.statusCode.toString()} : ${response.statusMessage.toString()}");

      default:
        Fluttertoast.showToast(msg: response.toString());
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
