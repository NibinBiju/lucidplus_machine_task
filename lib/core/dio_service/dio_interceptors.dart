import 'package:dio/dio.dart';
import 'package:lucidplus_machine_task/core/app_errors/app_errors.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // You can log request here
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(_mapDioError(err));
  }

  DioException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException("Connection timeout");

      case DioExceptionType.badResponse:
        throw ServerException(error.response?.data["detail"] ?? "Server error");

      case DioExceptionType.connectionError:
        throw NetworkException("No internet connection");

      default:
        throw AppException("Unexpected error occurred");
    }
  }
}
