import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';
import 'package:youscout_mobile/features/profile/domain/repositories/profile_repository.dart';

class GetMyProfile {
  final ProfileRepository _repository;
  const GetMyProfile(this._repository);

  Future<Either<Failure, Profile>> call() => _repository.getMyProfile();
}
