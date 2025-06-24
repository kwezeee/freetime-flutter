import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../services/token_store.dart';
import '../models/jwt.dart';
import '../utilities/endpoint.dart';

class UserApi {
  UserApi._() {
    final options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    );
    _dio = Dio(options);

    // ───── Disabilita verifica SSL solo per '192.168.68.56' ─────
    final adapter = IOHttpClientAdapter();
    adapter.createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => host == '192.168.68.56';
      return client;
    };
    _dio.httpClientAdapter = adapter;

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final (access, _) = await TokenStore.read();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        print('Dio error ► ${e.message}  status: ${e.response?.statusCode}');
        return handler.next(e);
      },
    ));
  }

  late final Dio _dio;
  static final instance = UserApi._();

  /// Ritorna `true` se l’e-mail esiste (200), `false` se 404.
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
