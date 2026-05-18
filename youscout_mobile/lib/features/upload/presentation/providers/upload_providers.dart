import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/network/dio_provider.dart';
import 'package:youscout_mobile/features/upload/data/datasources/content_remote_datasource.dart';
import 'package:youscout_mobile/features/upload/data/repositories/upload_repository_impl.dart';
import 'package:youscout_mobile/features/upload/domain/entities/upload_request.dart';
import 'package:youscout_mobile/features/upload/domain/repositories/upload_repository.dart';
import 'package:youscout_mobile/features/upload/domain/usecases/list_skills.dart';
import 'package:youscout_mobile/features/upload/domain/usecases/upload_video.dart';

final contentRemoteDatasourceProvider = Provider<ContentRemoteDatasource>(
  (ref) => ContentRemoteDatasourceImpl(ref.read(dioProvider)),
);

final uploadRepositoryProvider = Provider<UploadRepository>(
  (ref) => UploadRepositoryImpl(ref.read(contentRemoteDatasourceProvider)),
);

final uploadVideoUseCaseProvider = Provider<UploadVideo>(
  (ref) => UploadVideo(ref.read(uploadRepositoryProvider)),
);

final listSkillsUseCaseProvider = Provider<ListSkills>(
  (ref) => ListSkills(ref.read(uploadRepositoryProvider)),
);

// Loads available skills from content-service once
final skillsProvider = FutureProvider<List<String>>((ref) async {
  final useCase = ref.read(listSkillsUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (_) => <String>[],
    (skills) => skills,
  );
});

// Upload state
enum UploadStatus { idle, uploading, success, error }

class UploadState {
  final UploadStatus status;
  final String? errorMessage;
  final String? videoId;

  const UploadState({
    this.status = UploadStatus.idle,
    this.errorMessage,
    this.videoId,
  });
}

class UploadNotifier extends StateNotifier<UploadState> {
  final UploadVideo _uploadVideo;

  UploadNotifier(this._uploadVideo) : super(const UploadState());

  Future<void> upload(UploadRequest request) async {
    state = const UploadState(status: UploadStatus.uploading);
    final result = await _uploadVideo(request);
    result.fold(
      (failure) => state = UploadState(
        status: UploadStatus.error,
        errorMessage: failure.message,
      ),
      (videoId) => state = UploadState(
        status: UploadStatus.success,
        videoId: videoId,
      ),
    );
  }

  void reset() => state = const UploadState();
}

final uploadNotifierProvider = StateNotifierProvider<UploadNotifier, UploadState>(
  (ref) => UploadNotifier(ref.read(uploadVideoUseCaseProvider)),
);
