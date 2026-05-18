// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedItemModel {

 String get videoId; String get userId; String get uploaderName; String get description; List<String> get skills; String? get publishedAt;
/// Create a copy of FeedItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedItemModelCopyWith<FeedItemModel> get copyWith => _$FeedItemModelCopyWithImpl<FeedItemModel>(this as FeedItemModel, _$identity);

  /// Serializes this FeedItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItemModel&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,userId,uploaderName,description,const DeepCollectionEquality().hash(skills),publishedAt);

@override
String toString() {
  return 'FeedItemModel(videoId: $videoId, userId: $userId, uploaderName: $uploaderName, description: $description, skills: $skills, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $FeedItemModelCopyWith<$Res>  {
  factory $FeedItemModelCopyWith(FeedItemModel value, $Res Function(FeedItemModel) _then) = _$FeedItemModelCopyWithImpl;
@useResult
$Res call({
 String videoId, String userId, String uploaderName, String description, List<String> skills, String? publishedAt
});




}
/// @nodoc
class _$FeedItemModelCopyWithImpl<$Res>
    implements $FeedItemModelCopyWith<$Res> {
  _$FeedItemModelCopyWithImpl(this._self, this._then);

  final FeedItemModel _self;
  final $Res Function(FeedItemModel) _then;

/// Create a copy of FeedItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoId = null,Object? userId = null,Object? uploaderName = null,Object? description = null,Object? skills = null,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedItemModel].
extension FeedItemModelPatterns on FeedItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedItemModel value)  $default,){
final _that = this;
switch (_that) {
case _FeedItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeedItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String videoId,  String userId,  String uploaderName,  String description,  List<String> skills,  String? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedItemModel() when $default != null:
return $default(_that.videoId,_that.userId,_that.uploaderName,_that.description,_that.skills,_that.publishedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String videoId,  String userId,  String uploaderName,  String description,  List<String> skills,  String? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _FeedItemModel():
return $default(_that.videoId,_that.userId,_that.uploaderName,_that.description,_that.skills,_that.publishedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String videoId,  String userId,  String uploaderName,  String description,  List<String> skills,  String? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedItemModel() when $default != null:
return $default(_that.videoId,_that.userId,_that.uploaderName,_that.description,_that.skills,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedItemModel implements FeedItemModel {
  const _FeedItemModel({required this.videoId, required this.userId, required this.uploaderName, required this.description, final  List<String> skills = const [], this.publishedAt}): _skills = skills;
  factory _FeedItemModel.fromJson(Map<String, dynamic> json) => _$FeedItemModelFromJson(json);

@override final  String videoId;
@override final  String userId;
@override final  String uploaderName;
@override final  String description;
 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

@override final  String? publishedAt;

/// Create a copy of FeedItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedItemModelCopyWith<_FeedItemModel> get copyWith => __$FeedItemModelCopyWithImpl<_FeedItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedItemModel&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,userId,uploaderName,description,const DeepCollectionEquality().hash(_skills),publishedAt);

@override
String toString() {
  return 'FeedItemModel(videoId: $videoId, userId: $userId, uploaderName: $uploaderName, description: $description, skills: $skills, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedItemModelCopyWith<$Res> implements $FeedItemModelCopyWith<$Res> {
  factory _$FeedItemModelCopyWith(_FeedItemModel value, $Res Function(_FeedItemModel) _then) = __$FeedItemModelCopyWithImpl;
@override @useResult
$Res call({
 String videoId, String userId, String uploaderName, String description, List<String> skills, String? publishedAt
});




}
/// @nodoc
class __$FeedItemModelCopyWithImpl<$Res>
    implements _$FeedItemModelCopyWith<$Res> {
  __$FeedItemModelCopyWithImpl(this._self, this._then);

  final _FeedItemModel _self;
  final $Res Function(_FeedItemModel) _then;

/// Create a copy of FeedItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoId = null,Object? userId = null,Object? uploaderName = null,Object? description = null,Object? skills = null,Object? publishedAt = freezed,}) {
  return _then(_FeedItemModel(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
