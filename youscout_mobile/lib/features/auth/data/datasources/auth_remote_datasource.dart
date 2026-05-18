import 'package:dio/dio.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/network/api_endpoints.dart';
import 'package:youscout_mobile/features/auth/data/models/auth_response.dart';
import 'package:youscout_mobile/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthResponse> login({required String email, required String password});

  Future<UserModel> getMyProfile();

  Future<UserModel> updateProfile({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  const AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.register,
        data: {'email': email, 'password': password, 'displayName': displayName},
      );
      return AuthResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> login({required String email, required String password}) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getMyProfile() async {
    try {
      final res = await _dio.get(ApiEndpoints.myProfile);
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) async {
    try {
      final res = await _dio.put(
        ApiEndpoints.updateProfile,
        data: {
          'displayName': displayName,
          if (bio != null) 'bio': bio,
          if (position != null) 'position': position,
          if (foot != null) 'foot': foot,
        },
      );
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) throw const UnauthorizedException();
    if (e.response?.statusCode == 404) throw const NotFoundException();
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw NetworkException(message: e.message ?? 'Connection failed');
    }
    throw ServerException(e.response?.data?.toString() ?? e.message ?? 'Server error');
  }
}
