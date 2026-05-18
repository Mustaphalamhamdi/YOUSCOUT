import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:youscout_mobile/core/storage/secure_storage.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => const SecureStorage(FlutterSecureStorage()),
);

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(secureStorageProvider);
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  dio.interceptors.add(_AuthInterceptor(storage));
  dio.interceptors.add(_LoggingInterceptor(_logger));

  return dio;
});

class _AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  _AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  final Logger _log;
  _LoggingInterceptor(this._log);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.d('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.w('✗ ${err.response?.statusCode} ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }
}
