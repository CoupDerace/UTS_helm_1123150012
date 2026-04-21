import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constant.dart';
import 'secure_storage.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstant.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstant.receiveTimeout,
        ),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) async {
          debugPrint('Response: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) async {
          debugPrint('Error: ${error.response?.statusCode}');
          if (error.response?.statusCode == 401) {
            await SecureStorageService.clearAll();
          }
          handler.next(error);
        },
      ),
    );
    return dio;
  }
}
