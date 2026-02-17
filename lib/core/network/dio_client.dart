import 'package:dio/dio.dart';
import 'package:lucidplus_machine_task/core/network/dio_interceptors.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://taskmanager.uat-lplusltd.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AppInterceptors());
  }
}
