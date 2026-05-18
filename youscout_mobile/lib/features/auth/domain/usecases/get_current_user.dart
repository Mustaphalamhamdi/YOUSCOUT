import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/auth/domain/entities/user.dart';
import 'package:youscout_mobile/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository _repository;
  const GetCurrentUser(this._repository);

  Future<Either<Failure, User>> call() => _repository.getMyProfile();
}
