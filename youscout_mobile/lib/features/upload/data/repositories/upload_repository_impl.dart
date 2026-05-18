import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/upload/data/datasources/content_remote_datasource.dart';
import 'package:youscout_mobile/features/upload/domain/entities/upload_request.dart';
import 'package:youscout_mobile/features/upload/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final ContentRemoteDatasource _remote;
  const UploadRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, String>> uploadVideo(UploadRequest request) async {
    try {
      final response = await _remote.uploadVideo(
        filePath: request.filePath,
        description: request.description,
        skillCodes: request.skillCodes,
        hashtags: request.hashtags,
      );
      return Right(response.videoId);
    } on UnauthorizedException {
      return const Left(AuthFailure('Session expired'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> listSkills() async {
    try {
      final models = await _remote.listSkills();
      return Right(models.map((m) => m.code).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
