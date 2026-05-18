import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/upload/domain/entities/upload_request.dart';
import 'package:youscout_mobile/features/upload/domain/repositories/upload_repository.dart';

class UploadVideo {
  final UploadRepository _repository;
  const UploadVideo(this._repository);

  Future<Either<Failure, String>> call(UploadRequest request) =>
      _repository.uploadVideo(request);
}
