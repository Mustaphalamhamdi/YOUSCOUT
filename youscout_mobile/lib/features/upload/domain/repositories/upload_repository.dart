import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/upload/domain/entities/upload_request.dart';

abstract class UploadRepository {
  Future<Either<Failure, String>> uploadVideo(UploadRequest request);
  Future<Either<Failure, List<String>>> listSkills();
}
