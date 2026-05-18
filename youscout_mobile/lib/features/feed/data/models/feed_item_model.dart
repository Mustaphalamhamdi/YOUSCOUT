import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';

part 'feed_item_model.freezed.dart';
part 'feed_item_model.g.dart';

@freezed
abstract class FeedItemModel with _$FeedItemModel {
  const factory FeedItemModel({
    required String videoId,
    required String userId,
    required String uploaderName,
    required String description,
    @Default([]) List<String> skills,
    String? publishedAt,
  }) = _FeedItemModel;

  factory FeedItemModel.fromJson(Map<String, dynamic> json) => _$FeedItemModelFromJson(json);
}

extension FeedItemModelMapper on FeedItemModel {
  FeedItem toDomain({String? streamUrl}) => FeedItem(
        videoId: videoId,
        userId: userId,
        uploaderName: uploaderName,
        description: description,
        skills: skills,
        publishedAt: publishedAt,
        streamUrl: streamUrl,
      );
}
