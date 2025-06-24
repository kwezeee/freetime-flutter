import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // kept for optional certificate‑pinning

import '../services/token_store.dart';
import '../models/jwt.dart';
import '../utilities/endpoint.dart';

/// Centralised client for all user‑related endpoints (login, register, email‑exists)
/// Now points to the production BE and refuses insecure certificates.
class UserApi {
  UserApi._() {
    final options = BaseOptions(
      baseUrl: ApiConfig.baseUrl, // https://freetimeai.freeddns.org
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    );
    _dio = Dio(options);


    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final (access, _) = await TokenStore.read();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // Avoid leaking sensitive data in production logs.
        // Use your own logger instead of print.
        return handler.next(e);
      },
    ));
  }

  late final Dio _dio;
  static final instance = UserApi._();

  /// Returns `true` if the e‑mail exists (HTTP 200), `false` if 404.
  Future<bool> userExists(String email) async {
    try {
      await _dio.post('/users/exists', data: {'email': email});
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return false;
      rethrow;
    }
  }

  Future<JwtResponse> login(String email, String password) async {
    final res = await _dio.post('/users/login',
        data: {'email': email, 'password': password});
    return JwtResponse.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<JwtResponse> register(String email, String password) async {
    final res = await _dio.post('/users/register',
        data: {'email': email, 'password': password});
    return JwtResponse.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}