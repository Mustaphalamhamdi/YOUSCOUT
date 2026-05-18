import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_request.freezed.dart';

@freezed
abstract class UploadRequest with _$UploadRequest {
  const factory UploadRequest({
    required String filePath,
    required String description,
    required List<String> skillCodes,
    required List<String> hashtags,
  }) = _UploadRequest;
}
