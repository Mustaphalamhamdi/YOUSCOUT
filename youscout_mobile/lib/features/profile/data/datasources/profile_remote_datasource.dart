import 'package:dio/dio.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/network/api_endpoints.dart';
import 'package:youscout_mobile/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> updateMyProfile({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  });
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio _dio;
  const ProfileRemoteDatasourceImpl(this._dio);

  @override
  Future<ProfileModel> getMyProfile() async {
    try {
      final res = await _dio.get(ApiEndpoints.myProfile);
      return ProfileModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ProfileModel> updateMyProfile({
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
      return ProfileModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) throw const UnauthorizedException();
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException(message: e.message ?? 'Connection failed');
    }
    throw ServerException(e.response?.data?.toString() ?? e.message ?? 'Server error');
  }
}
