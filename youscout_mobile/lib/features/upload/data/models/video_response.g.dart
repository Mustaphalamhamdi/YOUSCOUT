// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoResponse _$VideoResponseFromJson(Map<String, dynamic> json) =>
    _VideoResponse(
      videoId: json['videoId'] as String,
      description: json['description'] as String,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VideoResponseToJson(_VideoResponse instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'description': instance.description,
      'skills': instance.skills,
    };
