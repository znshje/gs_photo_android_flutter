import 'package:dio/dio.dart';
import '../config/app_config.dart';

class DioAdapter {
  late final Dio dio;

  DioAdapter() {
    BaseOptions options = BaseOptions(
      baseUrl: "${AppConfig.baseUrl}:${AppConfig.port}${AppConfig.publicHead}",
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (AppConfig.authToken != null) {
          options.headers['Authorization'] = 'Bearer ${AppConfig.authToken}';
        }
        return handler.next(options);
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}
