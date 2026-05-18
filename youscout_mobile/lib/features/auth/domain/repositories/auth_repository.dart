import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/auth/domain/entities/user.dart';

// Abstract interface — domain knows nothing about HTTP or storage.
abstract class AuthRepository {
  Future<Either<Failure, ({User user, String token})>> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<Failure, ({User user, String token})>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getMyProfile();

  Future<bool> isAuthenticated();

  Future<void> logout();
}
