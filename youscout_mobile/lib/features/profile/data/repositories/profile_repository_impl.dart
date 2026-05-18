import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:youscout_mobile/features/profile/data/models/profile_model.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';
import 'package:youscout_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _remote;
  const ProfileRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
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
  Future<Either<Failure, Profile>> updateMyProfile({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) async {
    try {
      final model = await _remote.updateMyProfile(
        displayName: displayName,
        bio: bio,
        position: position,
        foot: foot,
      );
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
}
