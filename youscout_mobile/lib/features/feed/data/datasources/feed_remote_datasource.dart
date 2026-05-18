import 'package:dio/dio.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/network/api_endpoints.dart';
import 'package:youscout_mobile/features/feed/data/models/feed_item_model.dart';

abstract class FeedRemoteDatasource {
  Future<List<FeedItemModel>> getFeed({int limit = 20});
  Future<String> getStreamUrl(String videoId);
  Future<void> followUser(String followerId, String followeeId);
}

class FeedRemoteDatasourceImpl implements FeedRemoteDatasource {
  final Dio _dio;
  const FeedRemoteDatasourceImpl(this._dio);

  @override
  Future<List<FeedItemModel>> getFeed({int limit = 20}) async {
    try {
      final res = await _dio.get(
        ApiEndpoints.feed,
        queryParameters: {'limit': limit},
      );
      final list = res.data as List<dynamic>;
      return list
          .map((e) => FeedItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<String> getStreamUrl(String videoId) async {
    try {
      final res = await _dio.get(ApiEndpoints.streamUrl(videoId));
      return (res.data as Map<String, dynamic>)['presignedUrl'] as String;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> followUser(String followerId, String followeeId) async {
    try {
      await _dio.post(
        ApiEndpoints.follow,
        data: {'followerId': followerId, 'followeeId': followeeId},
      );
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
