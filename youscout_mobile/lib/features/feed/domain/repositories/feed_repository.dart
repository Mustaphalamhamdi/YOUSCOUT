import 'package:dartz/dartz.dart';
import 'package:youscout_mobile/core/error/failures.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';

abstract class FeedRepository {
  // Returns feed items with streamUrl already resolved.
  Future<Either<Failure, List<FeedItem>>> getFeed({int limit = 20});
}
