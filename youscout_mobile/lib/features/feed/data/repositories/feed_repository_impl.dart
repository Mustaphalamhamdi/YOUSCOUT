import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/exceptions.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:youscout_mobile/features/feed/data/models/feed_item_model.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';
import 'package:youscout_mobile/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDatasource _remote;
  const FeedRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<FeedItem>>> getFeed({int limit = 20}) async {
    try {
      final models = await _remote.getFeed(limit: limit);

      // Mobile client resolves stream URLs — in production a BFF would do this.
      // We fire requests concurrently to minimise latency.
      final items = await Future.wait(
        models.map((m) async {
          String? streamUrl;
          try {
            streamUrl = await _remote.getStreamUrl(m.videoId);
          } catch (_) {
            // Non-fatal: item still appears, just can't play
          }
          return m.toDomain(streamUrl: streamUrl);
        }),
      );

      return Right(items);
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
