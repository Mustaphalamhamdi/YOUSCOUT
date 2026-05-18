import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/core/storage/secure_storage.dart';
import 'package:youscout_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:youscout_mobile/features/auth/data/models/user_model.dart';
import 'package:youscout_mobile/features/auth/domain/entities/user.dart';
import 'package:youscout_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final SecureStorage _storage;

  const AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<Either<Failure, ({User user, String token})>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _remote.register(
        email: email, password: password, displayName: displayName,
      );
      await _storage.saveToken(response.token);
      await _storage.saveUserId(response.userId);
      final user = User(
        userId: response.userId,
        email: response.email,
        displayName: response.displayName,
      );
      return Right((user: user, token: response.token));
    } on UnauthorizedException {
      return const Left(AuthFailure('Invalid credentials'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({User user, String token})>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(email: email, password: password);
      await _storage.saveToken(response.token);
      await _storage.saveUserId(response.userId);
      final user = User(
        userId: response.userId,
        email: response.email,
        displayName: response.displayName,
      );
      return Right((user: user, token: response.token));
    } on UnauthorizedException {
      return const Left(AuthFailure('Invalid email or password'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getMyProfile() async {
    try {
      final model = await _remote.getMyProfile();
      return Right(model.toDomain());
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
  Future<bool> isAuthenticated() async {
    final token = await _storage.readToken();
    return token != null;
  }

  @override
  Future<void> logout() => _storage.clearAll();
}
