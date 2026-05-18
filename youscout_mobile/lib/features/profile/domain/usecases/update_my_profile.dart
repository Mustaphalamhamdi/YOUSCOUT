import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';
import 'package:youscout_mobile/features/profile/domain/repositories/profile_repository.dart';

class UpdateMyProfile {
  final ProfileRepository _repository;
  const UpdateMyProfile(this._repository);

  Future<Either<Failure, Profile>> call({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) =>
      _repository.updateMyProfile(
        displayName: displayName,
        bio: bio,
        position: position,
        foot: foot,
      );
}
