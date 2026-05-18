import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/upload/domain/repositories/upload_repository.dart';

class ListSkills {
  final UploadRepository _repository;
  const ListSkills(this._repository);

  Future<Either<Failure, List<String>>> call() => _repository.listSkills();
}
