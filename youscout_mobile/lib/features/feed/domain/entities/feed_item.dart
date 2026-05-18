import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_item.freezed.dart';

// Pure Dart entity.
// streamUrl is resolved lazily by the mobile client from content-service.
// In production a BFF would aggregate feed + stream URLs server-side.
@freezed
abstract class FeedItem with _$FeedItem {
  const factory FeedItem({
    required String videoId,
    required String userId,
    required String uploaderName,
    required String description,
    required List<String> skills,
    String? publishedAt,
    String? streamUrl, // populated after the second HTTP call
  }) = _FeedItem;
}
