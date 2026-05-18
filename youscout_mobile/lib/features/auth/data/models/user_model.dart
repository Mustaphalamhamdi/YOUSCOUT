import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youscout_mobile/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String userId,
    required String email,
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  User toDomain() => User(
        userId: userId,
        email: email,
        displayName: displayName,
        bio: bio,
        position: position,
        foot: foot,
      );
}
