import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/network/dio_provider.dart';
import 'package:youscout_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:youscout_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';
import 'package:youscout_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:youscout_mobile/features/profile/domain/usecases/get_my_profile.dart';
import 'package:youscout_mobile/features/profile/domain/usecases/update_my_profile.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>(
  (ref) => ProfileRemoteDatasourceImpl(ref.read(dioProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.read(profileRemoteDatasourceProvider)),
);

final getMyProfileUseCaseProvider = Provider<GetMyProfile>(
  (ref) => GetMyProfile(ref.read(profileRepositoryProvider)),
);

final updateMyProfileUseCaseProvider = Provider<UpdateMyProfile>(
  (ref) => UpdateMyProfile(ref.read(profileRepositoryProvider)),
);

class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() => _load();

  Future<Profile> _load() async {
    final useCase = ref.read(getMyProfileUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (profile) => profile,
    );
  }

  Future<void> saveProfile({
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) async {
    final useCase = ref.read(updateMyProfileUseCaseProvider);
    final result = await useCase(
      displayName: displayName,
      bio: bio,
      position: position,
      foot: foot,
    );
    result.fold(
      (failure) => throw Exception(failure.message),
      (profile) => state = AsyncValue.data(profile),
    );
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
);
