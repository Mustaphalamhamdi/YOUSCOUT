import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String userId,
    required String email,
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) = _Profile;
}
