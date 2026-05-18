import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/network/dio_provider.dart';
import 'package:youscout_mobile/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:youscout_mobile/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';
import 'package:youscout_mobile/features/feed/domain/repositories/feed_repository.dart';
import 'package:youscout_mobile/features/feed/domain/usecases/get_feed.dart';

final feedRemoteDatasourceProvider = Provider<FeedRemoteDatasource>(
  (ref) => FeedRemoteDatasourceImpl(ref.read(dioProvider)),
);

final feedRepositoryProvider = Provider<FeedRepository>(
  (ref) => FeedRepositoryImpl(ref.read(feedRemoteDatasourceProvider)),
);

final getFeedUseCaseProvider = Provider<GetFeed>(
  (ref) => GetFeed(ref.read(feedRepositoryProvider)),
);

// AsyncNotifier for feed — supports refresh and error handling
class FeedNotifier extends AsyncNotifier<List<FeedItem>> {
  @override
  Future<List<FeedItem>> build() => _load();

  Future<List<FeedItem>> _load() async {
    final useCase = ref.read(getFeedUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) => items,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load());
  }

  Future<void> followUser(String followerId, String followeeId) async {
    final datasource = ref.read(feedRemoteDatasourceProvider);
    await datasource.followUser(followerId, followeeId);
  }
}

final feedNotifierProvider = AsyncNotifierProvider<FeedNotifier, List<FeedItem>>(
  FeedNotifier.new,
);
