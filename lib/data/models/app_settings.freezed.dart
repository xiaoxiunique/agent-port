// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 List<ServerProfile> get profiles; String get activeProfileId; bool get hasCompletedOnboarding; double get refreshInterval; bool get keepScreenAwake; List<String> get quickActionButtons; List<String> get pinnedProjects; String get voiceRecognitionProvider; String get tencentAsrAppId; String get tencentAsrSecretId; String get tencentAsrSecretKey; String get tencentAsrToken;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&const DeepCollectionEquality().equals(other.profiles, profiles)&&(identical(other.activeProfileId, activeProfileId) || other.activeProfileId == activeProfileId)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding)&&(identical(other.refreshInterval, refreshInterval) || other.refreshInterval == refreshInterval)&&(identical(other.keepScreenAwake, keepScreenAwake) || other.keepScreenAwake == keepScreenAwake)&&const DeepCollectionEquality().equals(other.quickActionButtons, quickActionButtons)&&const DeepCollectionEquality().equals(other.pinnedProjects, pinnedProjects)&&(identical(other.voiceRecognitionProvider, voiceRecognitionProvider) || other.voiceRecognitionProvider == voiceRecognitionProvider)&&(identical(other.tencentAsrAppId, tencentAsrAppId) || other.tencentAsrAppId == tencentAsrAppId)&&(identical(other.tencentAsrSecretId, tencentAsrSecretId) || other.tencentAsrSecretId == tencentAsrSecretId)&&(identical(other.tencentAsrSecretKey, tencentAsrSecretKey) || other.tencentAsrSecretKey == tencentAsrSecretKey)&&(identical(other.tencentAsrToken, tencentAsrToken) || other.tencentAsrToken == tencentAsrToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(profiles),activeProfileId,hasCompletedOnboarding,refreshInterval,keepScreenAwake,const DeepCollectionEquality().hash(quickActionButtons),const DeepCollectionEquality().hash(pinnedProjects),voiceRecognitionProvider,tencentAsrAppId,tencentAsrSecretId,tencentAsrSecretKey,tencentAsrToken);

@override
String toString() {
  return 'AppSettings(profiles: $profiles, activeProfileId: $activeProfileId, hasCompletedOnboarding: $hasCompletedOnboarding, refreshInterval: $refreshInterval, keepScreenAwake: $keepScreenAwake, quickActionButtons: $quickActionButtons, pinnedProjects: $pinnedProjects, voiceRecognitionProvider: $voiceRecognitionProvider, tencentAsrAppId: $tencentAsrAppId, tencentAsrSecretId: $tencentAsrSecretId, tencentAsrSecretKey: $tencentAsrSecretKey, tencentAsrToken: $tencentAsrToken)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 List<ServerProfile> profiles, String activeProfileId, bool hasCompletedOnboarding, double refreshInterval, bool keepScreenAwake, List<String> quickActionButtons, List<String> pinnedProjects, String voiceRecognitionProvider, String tencentAsrAppId, String tencentAsrSecretId, String tencentAsrSecretKey, String tencentAsrToken
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profiles = null,Object? activeProfileId = null,Object? hasCompletedOnboarding = null,Object? refreshInterval = null,Object? keepScreenAwake = null,Object? quickActionButtons = null,Object? pinnedProjects = null,Object? voiceRecognitionProvider = null,Object? tencentAsrAppId = null,Object? tencentAsrSecretId = null,Object? tencentAsrSecretKey = null,Object? tencentAsrToken = null,}) {
  return _then(_self.copyWith(
profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<ServerProfile>,activeProfileId: null == activeProfileId ? _self.activeProfileId : activeProfileId // ignore: cast_nullable_to_non_nullable
as String,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,refreshInterval: null == refreshInterval ? _self.refreshInterval : refreshInterval // ignore: cast_nullable_to_non_nullable
as double,keepScreenAwake: null == keepScreenAwake ? _self.keepScreenAwake : keepScreenAwake // ignore: cast_nullable_to_non_nullable
as bool,quickActionButtons: null == quickActionButtons ? _self.quickActionButtons : quickActionButtons // ignore: cast_nullable_to_non_nullable
as List<String>,pinnedProjects: null == pinnedProjects ? _self.pinnedProjects : pinnedProjects // ignore: cast_nullable_to_non_nullable
as List<String>,voiceRecognitionProvider: null == voiceRecognitionProvider ? _self.voiceRecognitionProvider : voiceRecognitionProvider // ignore: cast_nullable_to_non_nullable
as String,tencentAsrAppId: null == tencentAsrAppId ? _self.tencentAsrAppId : tencentAsrAppId // ignore: cast_nullable_to_non_nullable
as String,tencentAsrSecretId: null == tencentAsrSecretId ? _self.tencentAsrSecretId : tencentAsrSecretId // ignore: cast_nullable_to_non_nullable
as String,tencentAsrSecretKey: null == tencentAsrSecretKey ? _self.tencentAsrSecretKey : tencentAsrSecretKey // ignore: cast_nullable_to_non_nullable
as String,tencentAsrToken: null == tencentAsrToken ? _self.tencentAsrToken : tencentAsrToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ServerProfile> profiles,  String activeProfileId,  bool hasCompletedOnboarding,  double refreshInterval,  bool keepScreenAwake,  List<String> quickActionButtons,  List<String> pinnedProjects,  String voiceRecognitionProvider,  String tencentAsrAppId,  String tencentAsrSecretId,  String tencentAsrSecretKey,  String tencentAsrToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.profiles,_that.activeProfileId,_that.hasCompletedOnboarding,_that.refreshInterval,_that.keepScreenAwake,_that.quickActionButtons,_that.pinnedProjects,_that.voiceRecognitionProvider,_that.tencentAsrAppId,_that.tencentAsrSecretId,_that.tencentAsrSecretKey,_that.tencentAsrToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ServerProfile> profiles,  String activeProfileId,  bool hasCompletedOnboarding,  double refreshInterval,  bool keepScreenAwake,  List<String> quickActionButtons,  List<String> pinnedProjects,  String voiceRecognitionProvider,  String tencentAsrAppId,  String tencentAsrSecretId,  String tencentAsrSecretKey,  String tencentAsrToken)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.profiles,_that.activeProfileId,_that.hasCompletedOnboarding,_that.refreshInterval,_that.keepScreenAwake,_that.quickActionButtons,_that.pinnedProjects,_that.voiceRecognitionProvider,_that.tencentAsrAppId,_that.tencentAsrSecretId,_that.tencentAsrSecretKey,_that.tencentAsrToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ServerProfile> profiles,  String activeProfileId,  bool hasCompletedOnboarding,  double refreshInterval,  bool keepScreenAwake,  List<String> quickActionButtons,  List<String> pinnedProjects,  String voiceRecognitionProvider,  String tencentAsrAppId,  String tencentAsrSecretId,  String tencentAsrSecretKey,  String tencentAsrToken)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.profiles,_that.activeProfileId,_that.hasCompletedOnboarding,_that.refreshInterval,_that.keepScreenAwake,_that.quickActionButtons,_that.pinnedProjects,_that.voiceRecognitionProvider,_that.tencentAsrAppId,_that.tencentAsrSecretId,_that.tencentAsrSecretKey,_that.tencentAsrToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({final  List<ServerProfile> profiles = const [], this.activeProfileId = '', this.hasCompletedOnboarding = false, this.refreshInterval = 2.5, this.keepScreenAwake = false, final  List<String> quickActionButtons = const [], final  List<String> pinnedProjects = const [], this.voiceRecognitionProvider = 'system', this.tencentAsrAppId = '', this.tencentAsrSecretId = '', this.tencentAsrSecretKey = '', this.tencentAsrToken = ''}): _profiles = profiles,_quickActionButtons = quickActionButtons,_pinnedProjects = pinnedProjects;
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

 final  List<ServerProfile> _profiles;
@override@JsonKey() List<ServerProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override@JsonKey() final  String activeProfileId;
@override@JsonKey() final  bool hasCompletedOnboarding;
@override@JsonKey() final  double refreshInterval;
@override@JsonKey() final  bool keepScreenAwake;
 final  List<String> _quickActionButtons;
@override@JsonKey() List<String> get quickActionButtons {
  if (_quickActionButtons is EqualUnmodifiableListView) return _quickActionButtons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quickActionButtons);
}

 final  List<String> _pinnedProjects;
@override@JsonKey() List<String> get pinnedProjects {
  if (_pinnedProjects is EqualUnmodifiableListView) return _pinnedProjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pinnedProjects);
}

@override@JsonKey() final  String voiceRecognitionProvider;
@override@JsonKey() final  String tencentAsrAppId;
@override@JsonKey() final  String tencentAsrSecretId;
@override@JsonKey() final  String tencentAsrSecretKey;
@override@JsonKey() final  String tencentAsrToken;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&const DeepCollectionEquality().equals(other._profiles, _profiles)&&(identical(other.activeProfileId, activeProfileId) || other.activeProfileId == activeProfileId)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding)&&(identical(other.refreshInterval, refreshInterval) || other.refreshInterval == refreshInterval)&&(identical(other.keepScreenAwake, keepScreenAwake) || other.keepScreenAwake == keepScreenAwake)&&const DeepCollectionEquality().equals(other._quickActionButtons, _quickActionButtons)&&const DeepCollectionEquality().equals(other._pinnedProjects, _pinnedProjects)&&(identical(other.voiceRecognitionProvider, voiceRecognitionProvider) || other.voiceRecognitionProvider == voiceRecognitionProvider)&&(identical(other.tencentAsrAppId, tencentAsrAppId) || other.tencentAsrAppId == tencentAsrAppId)&&(identical(other.tencentAsrSecretId, tencentAsrSecretId) || other.tencentAsrSecretId == tencentAsrSecretId)&&(identical(other.tencentAsrSecretKey, tencentAsrSecretKey) || other.tencentAsrSecretKey == tencentAsrSecretKey)&&(identical(other.tencentAsrToken, tencentAsrToken) || other.tencentAsrToken == tencentAsrToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles),activeProfileId,hasCompletedOnboarding,refreshInterval,keepScreenAwake,const DeepCollectionEquality().hash(_quickActionButtons),const DeepCollectionEquality().hash(_pinnedProjects),voiceRecognitionProvider,tencentAsrAppId,tencentAsrSecretId,tencentAsrSecretKey,tencentAsrToken);

@override
String toString() {
  return 'AppSettings(profiles: $profiles, activeProfileId: $activeProfileId, hasCompletedOnboarding: $hasCompletedOnboarding, refreshInterval: $refreshInterval, keepScreenAwake: $keepScreenAwake, quickActionButtons: $quickActionButtons, pinnedProjects: $pinnedProjects, voiceRecognitionProvider: $voiceRecognitionProvider, tencentAsrAppId: $tencentAsrAppId, tencentAsrSecretId: $tencentAsrSecretId, tencentAsrSecretKey: $tencentAsrSecretKey, tencentAsrToken: $tencentAsrToken)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 List<ServerProfile> profiles, String activeProfileId, bool hasCompletedOnboarding, double refreshInterval, bool keepScreenAwake, List<String> quickActionButtons, List<String> pinnedProjects, String voiceRecognitionProvider, String tencentAsrAppId, String tencentAsrSecretId, String tencentAsrSecretKey, String tencentAsrToken
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,Object? activeProfileId = null,Object? hasCompletedOnboarding = null,Object? refreshInterval = null,Object? keepScreenAwake = null,Object? quickActionButtons = null,Object? pinnedProjects = null,Object? voiceRecognitionProvider = null,Object? tencentAsrAppId = null,Object? tencentAsrSecretId = null,Object? tencentAsrSecretKey = null,Object? tencentAsrToken = null,}) {
  return _then(_AppSettings(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<ServerProfile>,activeProfileId: null == activeProfileId ? _self.activeProfileId : activeProfileId // ignore: cast_nullable_to_non_nullable
as String,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,refreshInterval: null == refreshInterval ? _self.refreshInterval : refreshInterval // ignore: cast_nullable_to_non_nullable
as double,keepScreenAwake: null == keepScreenAwake ? _self.keepScreenAwake : keepScreenAwake // ignore: cast_nullable_to_non_nullable
as bool,quickActionButtons: null == quickActionButtons ? _self._quickActionButtons : quickActionButtons // ignore: cast_nullable_to_non_nullable
as List<String>,pinnedProjects: null == pinnedProjects ? _self._pinnedProjects : pinnedProjects // ignore: cast_nullable_to_non_nullable
as List<String>,voiceRecognitionProvider: null == voiceRecognitionProvider ? _self.voiceRecognitionProvider : voiceRecognitionProvider // ignore: cast_nullable_to_non_nullable
as String,tencentAsrAppId: null == tencentAsrAppId ? _self.tencentAsrAppId : tencentAsrAppId // ignore: cast_nullable_to_non_nullable
as String,tencentAsrSecretId: null == tencentAsrSecretId ? _self.tencentAsrSecretId : tencentAsrSecretId // ignore: cast_nullable_to_non_nullable
as String,tencentAsrSecretKey: null == tencentAsrSecretKey ? _self.tencentAsrSecretKey : tencentAsrSecretKey // ignore: cast_nullable_to_non_nullable
as String,tencentAsrToken: null == tencentAsrToken ? _self.tencentAsrToken : tencentAsrToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
