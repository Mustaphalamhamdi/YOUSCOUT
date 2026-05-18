// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UploadRequest {

 String get filePath; String get description; List<String> get skillCodes; List<String> get hashtags;
/// Create a copy of UploadRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadRequestCopyWith<UploadRequest> get copyWith => _$UploadRequestCopyWithImpl<UploadRequest>(this as UploadRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRequest&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.skillCodes, skillCodes)&&const DeepCollectionEquality().equals(other.hashtags, hashtags));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,description,const DeepCollectionEquality().hash(skillCodes),const DeepCollectionEquality().hash(hashtags));

@override
String toString() {
  return 'UploadRequest(filePath: $filePath, description: $description, skillCodes: $skillCodes, hashtags: $hashtags)';
}


}

/// @nodoc
abstract mixin class $UploadRequestCopyWith<$Res>  {
  factory $UploadRequestCopyWith(UploadRequest value, $Res Function(UploadRequest) _then) = _$UploadRequestCopyWithImpl;
@useResult
$Res call({
 String filePath, String description, List<String> skillCodes, List<String> hashtags
});




}
/// @nodoc
class _$UploadRequestCopyWithImpl<$Res>
    implements $UploadRequestCopyWith<$Res> {
  _$UploadRequestCopyWithImpl(this._self, this._then);

  final UploadRequest _self;
  final $Res Function(UploadRequest) _then;

/// Create a copy of UploadRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filePath = null,Object? description = null,Object? skillCodes = null,Object? hashtags = null,}) {
  return _then(_self.copyWith(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skillCodes: null == skillCodes ? _self.skillCodes : skillCodes // ignore: cast_nullable_to_non_nullable
as List<String>,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadRequest].
extension UploadRequestPatterns on UploadRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadRequest value)  $default,){
final _that = this;
switch (_that) {
case _UploadRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UploadRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filePath,  String description,  List<String> skillCodes,  List<String> hashtags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadRequest() when $default != null:
return $default(_that.filePath,_that.description,_that.skillCodes,_that.hashtags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filePath,  String description,  List<String> skillCodes,  List<String> hashtags)  $default,) {final _that = this;
switch (_that) {
case _UploadRequest():
return $default(_that.filePath,_that.description,_that.skillCodes,_that.hashtags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filePath,  String description,  List<String> skillCodes,  List<String> hashtags)?  $default,) {final _that = this;
switch (_that) {
case _UploadRequest() when $default != null:
return $default(_that.filePath,_that.description,_that.skillCodes,_that.hashtags);case _:
  return null;

}
}

}

/// @nodoc


class _UploadRequest implements UploadRequest {
  const _UploadRequest({required this.filePath, required this.description, required final  List<String> skillCodes, required final  List<String> hashtags}): _skillCodes = skillCodes,_hashtags = hashtags;
  

@override final  String filePath;
@override final  String description;
 final  List<String> _skillCodes;
@override List<String> get skillCodes {
  if (_skillCodes is EqualUnmodifiableListView) return _skillCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skillCodes);
}

 final  List<String> _hashtags;
@override List<String> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}


/// Create a copy of UploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadRequestCopyWith<_UploadRequest> get copyWith => __$UploadRequestCopyWithImpl<_UploadRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadRequest&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._skillCodes, _skillCodes)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,description,const DeepCollectionEquality().hash(_skillCodes),const DeepCollectionEquality().hash(_hashtags));

@override
String toString() {
  return 'UploadRequest(filePath: $filePath, description: $description, skillCodes: $skillCodes, hashtags: $hashtags)';
}


}

/// @nodoc
abstract mixin class _$UploadRequestCopyWith<$Res> implements $UploadRequestCopyWith<$Res> {
  factory _$UploadRequestCopyWith(_UploadRequest value, $Res Function(_UploadRequest) _then) = __$UploadRequestCopyWithImpl;
@override @useResult
$Res call({
 String filePath, String description, List<String> skillCodes, List<String> hashtags
});




}
/// @nodoc
class __$UploadRequestCopyWithImpl<$Res>
    implements _$UploadRequestCopyWith<$Res> {
  __$UploadRequestCopyWithImpl(this._self, this._then);

  final _UploadRequest _self;
  final $Res Function(_UploadRequest) _then;

/// Create a copy of UploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filePath = null,Object? description = null,Object? skillCodes = null,Object? hashtags = null,}) {
  return _then(_UploadRequest(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,skillCodes: null == skillCodes ? _self._skillCodes : skillCodes // ignore: cast_nullable_to_non_nullable
as List<String>,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
