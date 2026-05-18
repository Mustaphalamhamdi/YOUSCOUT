import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String userId,
    required String email,
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

extension ProfileModelMapper on ProfileModel {
  Profile toDomain() => Profile(
        userId: userId,
        email: email,
        displayName: displayName,
        bio: bio,
        position: position,
        foot: foot,
      );
}
