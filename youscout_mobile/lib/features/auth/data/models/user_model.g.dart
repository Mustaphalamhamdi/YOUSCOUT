// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  userId: json['userId'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  bio: json['bio'] as String?,
  position: json['position'] as String?,
  foot: json['foot'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'position': instance.position,
      'foot': instance.foot,
    };
