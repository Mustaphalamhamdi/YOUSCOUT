import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';
import 'package:youscout_mobile/features/feed/domain/repositories/feed_repository.dart';

class GetFeed {
  final FeedRepository _repository;
  const GetFeed(this._repository);

  Future<Either<Failure, List<FeedItem>>> call({int limit = 20}) =>
      _repository.getFeed(limit: limit);
}
