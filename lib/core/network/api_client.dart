import 'package:dio/dio.dart';
import 'dio_adapter.dart';

class ApiClient {
  final DioAdapter _adapter = DioAdapter();

  Dio get dio => _adapter.dio;

  Future<Response> post(String path, {dynamic data}) async {
    return _adapter.post(path, data: data);
  }
}
