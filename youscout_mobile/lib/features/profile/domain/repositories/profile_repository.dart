import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getMyProfile();

  Future<Either<Failure, Profile>> updateMyProfile({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  });
}
