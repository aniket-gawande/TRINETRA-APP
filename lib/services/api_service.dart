import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS simulator, or your backend URL
  static const String baseUrl = kIsWeb 
      ? 'http://localhost:5000/api'
      : 'http://10.0.2.2:5000/api'; 
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  ApiService() {
    // Request Interceptor (Adds Token for mobile only)
    if (!kIsWeb) {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // Firebase token would be added here on real mobile device
            // For now, continue without token
          } catch (e) {
            // Token retrieval failed, continue without auth
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Handle authentication error
          }
          return handler.next(e);
        },
      ));
    }
  }

  Dio get client => _dio;
}