import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

// Pure Dart entity — no Flutter, no Dio, no JSON imports.
@freezed
abstract class User with _$User {
  const factory User({
    required String userId,
    required String email,
    required String displayName,
    String? bio,
    String? position,
    String? foot,
  }) = _User;
}
