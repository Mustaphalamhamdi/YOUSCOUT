import 'package:dio/dio.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/network/api_endpoints.dart';
import 'package:youscout_mobile/features/upload/data/models/skill_model.dart';
import 'package:youscout_mobile/features/upload/data/models/video_response.dart';

abstract class ContentRemoteDatasource {
  Future<VideoResponse> uploadVideo({
    required String filePath,
    required String description,
    required List<String> skillCodes,
    required List<String> hashtags,
  });

  Future<List<SkillModel>> listSkills();
}

class ContentRemoteDatasourceImpl implements ContentRemoteDatasource {
  final Dio _dio;
  const ContentRemoteDatasourceImpl(this._dio);

  @override
  Future<VideoResponse> uploadVideo({
    required String filePath,
    required String description,
    required List<String> skillCodes,
    required List<String> hashtags,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
        'description': description,
        if (skillCodes.isNotEmpty) 'skills': skillCodes,
        if (hashtags.isNotEmpty) 'hashtags': hashtags,
      });

      final res = await _dio.post(
        ApiEndpoints.uploadVideo,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data; boundary=${formData.boundary}',
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      return VideoResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<SkillModel>> listSkills() async {
    try {
      final res = await _dio.get(ApiEndpoints.skills);
      final list = res.data as List<dynamic>;
      return list
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401 || status == 403) throw const UnauthorizedException();
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException(message: e.message ?? 'Connection failed');
    }
    throw ServerException(e.response?.data?.toString() ?? e.message ?? 'Server error');
  }
}
