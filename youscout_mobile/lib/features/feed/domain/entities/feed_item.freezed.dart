// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedItem {

 String get videoId; String get userId; String get uploaderName; String get description; List<String> get skills; String? get publishedAt; String? get streamUrl;
/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedItemCopyWith<FeedItem> get copyWith => _$FeedItemCopyWithImpl<FeedItem>(this as FeedItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItem&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl));
}


@override
int get hashCode => Object.hash(runtimeType,videoId,userId,uploaderName,description,const DeepCollectionEquality().hash(skills),publishedAt,streamUrl);

@override
String toString() {
  return 'FeedItem(videoId: $videoId, userId: $userId, uploaderName: $uploaderName, description: $description, skills: $skills, publishedAt: $publishedAt, streamUrl: $streamUrl)';
}


}

/// @nodoc
abstract mixin class $FeedItemCopyWith<$Res>  {
  factory $FeedItemCopyWith(FeedItem value, $Res Function(FeedItem) _then) = _$FeedItemCopyWithImpl;
@useResult
$Res call({
 String videoId, String userId, String uploaderName, String description, List<String> skills, String? publishedAt, String? streamUrl
});




}
/// @nodoc
class _$FeedItemCopyWithImpl<$Res>
    implements $FeedItemCopyWith<$Res> {
  _$FeedItemCopyWithImpl(this._self, this._then);

  final FeedItem _self;
  final $Res Function(FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoId = null,Object? userId = null,Object? uploaderName = null,Object? description = null,Object? skills = null,Object? publishedAt = freezed,Object? streamUrl = freezed,}) {
  return _then(_self.copyWith(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedItem].
extension FeedItemPatterns on FeedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedItem value)  $default,){
final _that = this;
switch (_that) {
case _FeedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedItem value)?  $default,){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String videoId,  String userId,  String uploaderName,  String description,  List<String> skills,  String? publishedAt,  String? streamUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.videoId,_that.userId,_that.uploaderName,_that.description,_that.skills,_that.publishedAt,_that.streamUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String videoId,  String userId,  String uploaderName,  String description,  List<String> skills,  String? publishedAt,  String? streamUrl)  $default,) {final _that = this;
switch (_that) {
case _FeedItem():
return $default(_that.videoId,_that.userId,_that.uploaderName,_that.description,_that.skills,_that.publishedAt,_that.streamUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String videoId,  String userId,  String uploaderName,  String description,  List<String> skills,  String? publishedAt,  String? streamUrl)?  $default,) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.videoId,_that.userId,_that.uploaderName,_that.description,_that.skills,_that.publishedAt,_that.streamUrl);case _:
  return null;

}
}

}

/// @nodoc


class _FeedItem implements FeedItem {
  const _FeedItem({required this.videoId, required this.userId, required this.uploaderName, required this.description, required final  List<String> skills, this.publishedAt, this.streamUrl}): _skills = skills;
  

@override final  String videoId;
@override final  String userId;
@override final  String uploaderName;
@override final  String description;
 final  List<String> _skills;
@override List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

@override final  String? publishedAt;
@override final  String? streamUrl;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedItemCopyWith<_FeedItem> get copyWith => __$FeedItemCopyWithImpl<_FeedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedItem&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl));
}


@override
int get hashCode => Object.hash(runtimeType,videoId,userId,uploaderName,description,const DeepCollectionEquality().hash(_skills),publishedAt,streamUrl);

@override
String toString() {
  return 'FeedItem(videoId: $videoId, userId: $userId, uploaderName: $uploaderName, description: $description, skills: $skills, publishedAt: $publishedAt, streamUrl: $streamUrl)';
}


}

/// @nodoc
abstract mixin class _$FeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory _$FeedItemCopyWith(_FeedItem value, $Res Function(_FeedItem) _then) = __$FeedItemCopyWithImpl;
@override @useResult
$Res call({
 String videoId, String userId, String uploaderName, String description, List<String> skills, String? publishedAt, String? streamUrl
});




}
/// @nodoc
class __$FeedItemCopyWithImpl<$Res>
    implements _$FeedItemCopyWith<$Res> {
  __$FeedItemCopyWithImpl(this._self, this._then);

  final _FeedItem _self;
  final $Res Function(_FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoId = null,Object? userId = null,Object? uploaderName = null,Object? description = null,Object? skills = null,Object? publishedAt = freezed,Object? streamUrl = freezed,}) {
  return _then(_FeedItem(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
