import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_response.freezed.dart';
part 'video_response.g.dart';

@freezed
abstract class VideoResponse with _$VideoResponse {
  const factory VideoResponse({
    required String videoId,
    required String description,
    @Default([]) List<String> skills,
  }) = _VideoResponse;

  factory VideoResponse.fromJson(Map<String, dynamic> json) => _$VideoResponseFromJson(json);
}
