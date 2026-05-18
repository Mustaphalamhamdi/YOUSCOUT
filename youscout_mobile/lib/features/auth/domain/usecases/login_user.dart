import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/auth/domain/entities/user.dart';
import 'package:youscout_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;
  const LoginUser(this._repository);

  Future<Either<Failure, ({User user, String token})>> call({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);
}
