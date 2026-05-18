// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedItemModel _$FeedItemModelFromJson(Map<String, dynamic> json) =>
    _FeedItemModel(
      videoId: json['videoId'] as String,
      userId: json['userId'] as String,
      uploaderName: json['uploaderName'] as String,
      description: json['description'] as String,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      publishedAt: json['publishedAt'] as String?,
    );

Map<String, dynamic> _$FeedItemModelToJson(_FeedItemModel instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'userId': instance.userId,
      'uploaderName': instance.uploaderName,
      'description': instance.description,
      'skills': instance.skills,
      'publishedAt': instance.publishedAt,
    };
