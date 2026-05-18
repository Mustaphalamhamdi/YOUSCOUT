// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoResponse {

 String get videoId; String get description; List<String> get skills;
/// Create a copy of VideoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoResponseCopyWith<VideoResponse> get copyWith => _$VideoResponseCopyWithImpl<VideoResponse>(this as VideoResponse, _$identity);

  /// Serializes this VideoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoResponse&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.skills, skills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,description,const DeepCollectionEquality().hash(skills));

@override
String toString() {
  return 'VideoResponse(videoId: $videoId, description: $description, skills: $skills)';
}


}

/// @nodoc
abstract mixin class $VideoResponseCopyWith<$Res>  {
  factory $VideoResponseCopyWith(VideoResponse value, $Res Function(VideoResponse) _then) = _$VideoResponseCopyWithImpl;
@useResult
$Res call({
 String videoId, String description, List<String> skills
});




}
/// @nodoc
class _$VideoResponseCopyWithImpl<$Res>
    implements $VideoResponseCopyWith<$Res> {
  _$VideoResponseCopyWithImpl(this._self, this._then);

  final VideoResponse _self;
  final $Res Function(VideoResponse) _then;

/// Create a copy of VideoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoId = null,Object? description = null,Object? skills = null,}) {
  return _then(_self.copyWith(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoResponse].
extension VideoResponsePatterns on VideoResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoResponse value)  $default,){
final _that = this;
switch (_that) {
case _VideoResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoResponse value)?  $default,){
final _that = this;
switch (_that) {
case _VideoResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String videoId,  String description,  List<String> skills)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoResponse() when $default != null:
return $default(_that.videoId,_that.description,_that.skills);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String videoId,  String description,  List<String> skills)  $default,) {final _that = this;
switch (_that) {
case _VideoResponse():
return $default(_that.videoId,_that.description,_that.skills);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String videoId,  String description,  List<String> skills)?  $default,) {final _that = this;
switch (_that) {
case _VideoResponse() when $default != null:
return $default(_that.videoId,_that.description,_that.skills);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoResponse implements VideoResponse {
  const _VideoResponse({required this.videoId, required this.description, final  List<String> skills = const []}): _skills = skills;
  factory _VideoResponse.fromJson(Map<String, dynamic> json) => _$VideoResponseFromJson(json);

@override final  String videoId;
@override final  String description;
 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}


/// Create a copy of VideoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoResponseCopyWith<_VideoResponse> get copyWith => __$VideoResponseCopyWithImpl<_VideoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoResponse&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._skills, _skills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,description,const DeepCollectionEquality().hash(_skills));

@override
String toString() {
  return 'VideoResponse(videoId: $videoId, description: $description, skills: $skills)';
}


}

/// @nodoc
abstract mixin class _$VideoResponseCopyWith<$Res> implements $VideoResponseCopyWith<$Res> {
  factory _$VideoResponseCopyWith(_VideoResponse value, $Res Function(_VideoResponse) _then) = __$VideoResponseCopyWithImpl;
@override @useResult
$Res call({
 String videoId, String description, List<String> skills
});




}
/// @nodoc
class __$VideoResponseCopyWithImpl<$Res>
    implements _$VideoResponseCopyWith<$Res> {
  __$VideoResponseCopyWithImpl(this._self, this._then);

  final _VideoResponse _self;
  final $Res Function(_VideoResponse) _then;

/// Create a copy of VideoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoId = null,Object? description = null,Object? skills = null,}) {
  return _then(_VideoResponse(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
