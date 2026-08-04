// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'files.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileRoot {

 String get path; String get name;
/// Create a copy of FileRoot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileRootCopyWith<FileRoot> get copyWith => _$FileRootCopyWithImpl<FileRoot>(this as FileRoot, _$identity);

  /// Serializes this FileRoot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileRoot&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name);

@override
String toString() {
  return 'FileRoot(path: $path, name: $name)';
}


}

/// @nodoc
abstract mixin class $FileRootCopyWith<$Res>  {
  factory $FileRootCopyWith(FileRoot value, $Res Function(FileRoot) _then) = _$FileRootCopyWithImpl;
@useResult
$Res call({
 String path, String name
});




}
/// @nodoc
class _$FileRootCopyWithImpl<$Res>
    implements $FileRootCopyWith<$Res> {
  _$FileRootCopyWithImpl(this._self, this._then);

  final FileRoot _self;
  final $Res Function(FileRoot) _then;

/// Create a copy of FileRoot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FileRoot].
extension FileRootPatterns on FileRoot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileRoot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileRoot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileRoot value)  $default,){
final _that = this;
switch (_that) {
case _FileRoot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileRoot value)?  $default,){
final _that = this;
switch (_that) {
case _FileRoot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileRoot() when $default != null:
return $default(_that.path,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name)  $default,) {final _that = this;
switch (_that) {
case _FileRoot():
return $default(_that.path,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name)?  $default,) {final _that = this;
switch (_that) {
case _FileRoot() when $default != null:
return $default(_that.path,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileRoot implements FileRoot {
  const _FileRoot({required this.path, required this.name});
  factory _FileRoot.fromJson(Map<String, dynamic> json) => _$FileRootFromJson(json);

@override final  String path;
@override final  String name;

/// Create a copy of FileRoot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileRootCopyWith<_FileRoot> get copyWith => __$FileRootCopyWithImpl<_FileRoot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileRootToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileRoot&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name);

@override
String toString() {
  return 'FileRoot(path: $path, name: $name)';
}


}

/// @nodoc
abstract mixin class _$FileRootCopyWith<$Res> implements $FileRootCopyWith<$Res> {
  factory _$FileRootCopyWith(_FileRoot value, $Res Function(_FileRoot) _then) = __$FileRootCopyWithImpl;
@override @useResult
$Res call({
 String path, String name
});




}
/// @nodoc
class __$FileRootCopyWithImpl<$Res>
    implements _$FileRootCopyWith<$Res> {
  __$FileRootCopyWithImpl(this._self, this._then);

  final _FileRoot _self;
  final $Res Function(_FileRoot) _then;

/// Create a copy of FileRoot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,}) {
  return _then(_FileRoot(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FileEntry {

 String get name; String get path; bool get isDir; int get size;/// Seconds since the epoch; absent when the platform won't report it.
 double? get modified;
/// Create a copy of FileEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileEntryCopyWith<FileEntry> get copyWith => _$FileEntryCopyWithImpl<FileEntry>(this as FileEntry, _$identity);

  /// Serializes this FileEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.isDir, isDir) || other.isDir == isDir)&&(identical(other.size, size) || other.size == size)&&(identical(other.modified, modified) || other.modified == modified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,isDir,size,modified);

@override
String toString() {
  return 'FileEntry(name: $name, path: $path, isDir: $isDir, size: $size, modified: $modified)';
}


}

/// @nodoc
abstract mixin class $FileEntryCopyWith<$Res>  {
  factory $FileEntryCopyWith(FileEntry value, $Res Function(FileEntry) _then) = _$FileEntryCopyWithImpl;
@useResult
$Res call({
 String name, String path, bool isDir, int size, double? modified
});




}
/// @nodoc
class _$FileEntryCopyWithImpl<$Res>
    implements $FileEntryCopyWith<$Res> {
  _$FileEntryCopyWithImpl(this._self, this._then);

  final FileEntry _self;
  final $Res Function(FileEntry) _then;

/// Create a copy of FileEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? isDir = null,Object? size = null,Object? modified = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,isDir: null == isDir ? _self.isDir : isDir // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,modified: freezed == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FileEntry].
extension FileEntryPatterns on FileEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileEntry value)  $default,){
final _that = this;
switch (_that) {
case _FileEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileEntry value)?  $default,){
final _that = this;
switch (_that) {
case _FileEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  bool isDir,  int size,  double? modified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileEntry() when $default != null:
return $default(_that.name,_that.path,_that.isDir,_that.size,_that.modified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  bool isDir,  int size,  double? modified)  $default,) {final _that = this;
switch (_that) {
case _FileEntry():
return $default(_that.name,_that.path,_that.isDir,_that.size,_that.modified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  bool isDir,  int size,  double? modified)?  $default,) {final _that = this;
switch (_that) {
case _FileEntry() when $default != null:
return $default(_that.name,_that.path,_that.isDir,_that.size,_that.modified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileEntry implements FileEntry {
  const _FileEntry({required this.name, required this.path, required this.isDir, this.size = 0, this.modified});
  factory _FileEntry.fromJson(Map<String, dynamic> json) => _$FileEntryFromJson(json);

@override final  String name;
@override final  String path;
@override final  bool isDir;
@override@JsonKey() final  int size;
/// Seconds since the epoch; absent when the platform won't report it.
@override final  double? modified;

/// Create a copy of FileEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileEntryCopyWith<_FileEntry> get copyWith => __$FileEntryCopyWithImpl<_FileEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.isDir, isDir) || other.isDir == isDir)&&(identical(other.size, size) || other.size == size)&&(identical(other.modified, modified) || other.modified == modified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,isDir,size,modified);

@override
String toString() {
  return 'FileEntry(name: $name, path: $path, isDir: $isDir, size: $size, modified: $modified)';
}


}

/// @nodoc
abstract mixin class _$FileEntryCopyWith<$Res> implements $FileEntryCopyWith<$Res> {
  factory _$FileEntryCopyWith(_FileEntry value, $Res Function(_FileEntry) _then) = __$FileEntryCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, bool isDir, int size, double? modified
});




}
/// @nodoc
class __$FileEntryCopyWithImpl<$Res>
    implements _$FileEntryCopyWith<$Res> {
  __$FileEntryCopyWithImpl(this._self, this._then);

  final _FileEntry _self;
  final $Res Function(_FileEntry) _then;

/// Create a copy of FileEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? isDir = null,Object? size = null,Object? modified = freezed,}) {
  return _then(_FileEntry(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,isDir: null == isDir ? _self.isDir : isDir // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,modified: freezed == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$FileListing {

 String get path;/// The root this path sits under. Navigation stops here rather than
/// walking up into a path the host would reject.
 String get root; List<FileEntry> get entries;/// True when noise directories (.git, node_modules, …) and dotfiles were
/// hidden.
 bool get filtered;
/// Create a copy of FileListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileListingCopyWith<FileListing> get copyWith => _$FileListingCopyWithImpl<FileListing>(this as FileListing, _$identity);

  /// Serializes this FileListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileListing&&(identical(other.path, path) || other.path == path)&&(identical(other.root, root) || other.root == root)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.filtered, filtered) || other.filtered == filtered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,root,const DeepCollectionEquality().hash(entries),filtered);

@override
String toString() {
  return 'FileListing(path: $path, root: $root, entries: $entries, filtered: $filtered)';
}


}

/// @nodoc
abstract mixin class $FileListingCopyWith<$Res>  {
  factory $FileListingCopyWith(FileListing value, $Res Function(FileListing) _then) = _$FileListingCopyWithImpl;
@useResult
$Res call({
 String path, String root, List<FileEntry> entries, bool filtered
});




}
/// @nodoc
class _$FileListingCopyWithImpl<$Res>
    implements $FileListingCopyWith<$Res> {
  _$FileListingCopyWithImpl(this._self, this._then);

  final FileListing _self;
  final $Res Function(FileListing) _then;

/// Create a copy of FileListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? root = null,Object? entries = null,Object? filtered = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,filtered: null == filtered ? _self.filtered : filtered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FileListing].
extension FileListingPatterns on FileListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileListing value)  $default,){
final _that = this;
switch (_that) {
case _FileListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileListing value)?  $default,){
final _that = this;
switch (_that) {
case _FileListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String root,  List<FileEntry> entries,  bool filtered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileListing() when $default != null:
return $default(_that.path,_that.root,_that.entries,_that.filtered);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String root,  List<FileEntry> entries,  bool filtered)  $default,) {final _that = this;
switch (_that) {
case _FileListing():
return $default(_that.path,_that.root,_that.entries,_that.filtered);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String root,  List<FileEntry> entries,  bool filtered)?  $default,) {final _that = this;
switch (_that) {
case _FileListing() when $default != null:
return $default(_that.path,_that.root,_that.entries,_that.filtered);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileListing implements FileListing {
  const _FileListing({required this.path, required this.root, final  List<FileEntry> entries = const [], this.filtered = true}): _entries = entries;
  factory _FileListing.fromJson(Map<String, dynamic> json) => _$FileListingFromJson(json);

@override final  String path;
/// The root this path sits under. Navigation stops here rather than
/// walking up into a path the host would reject.
@override final  String root;
 final  List<FileEntry> _entries;
@override@JsonKey() List<FileEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

/// True when noise directories (.git, node_modules, …) and dotfiles were
/// hidden.
@override@JsonKey() final  bool filtered;

/// Create a copy of FileListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileListingCopyWith<_FileListing> get copyWith => __$FileListingCopyWithImpl<_FileListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileListing&&(identical(other.path, path) || other.path == path)&&(identical(other.root, root) || other.root == root)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.filtered, filtered) || other.filtered == filtered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,root,const DeepCollectionEquality().hash(_entries),filtered);

@override
String toString() {
  return 'FileListing(path: $path, root: $root, entries: $entries, filtered: $filtered)';
}


}

/// @nodoc
abstract mixin class _$FileListingCopyWith<$Res> implements $FileListingCopyWith<$Res> {
  factory _$FileListingCopyWith(_FileListing value, $Res Function(_FileListing) _then) = __$FileListingCopyWithImpl;
@override @useResult
$Res call({
 String path, String root, List<FileEntry> entries, bool filtered
});




}
/// @nodoc
class __$FileListingCopyWithImpl<$Res>
    implements _$FileListingCopyWith<$Res> {
  __$FileListingCopyWithImpl(this._self, this._then);

  final _FileListing _self;
  final $Res Function(_FileListing) _then;

/// Create a copy of FileListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? root = null,Object? entries = null,Object? filtered = null,}) {
  return _then(_FileListing(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,filtered: null == filtered ? _self.filtered : filtered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FilePreview {

 bool get text; String get content; int get size;/// `image` or `video` when the file can be displayed directly.
 String? get media; String? get reason;
/// Create a copy of FilePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilePreviewCopyWith<FilePreview> get copyWith => _$FilePreviewCopyWithImpl<FilePreview>(this as FilePreview, _$identity);

  /// Serializes this FilePreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilePreview&&(identical(other.text, text) || other.text == text)&&(identical(other.content, content) || other.content == content)&&(identical(other.size, size) || other.size == size)&&(identical(other.media, media) || other.media == media)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,content,size,media,reason);

@override
String toString() {
  return 'FilePreview(text: $text, content: $content, size: $size, media: $media, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $FilePreviewCopyWith<$Res>  {
  factory $FilePreviewCopyWith(FilePreview value, $Res Function(FilePreview) _then) = _$FilePreviewCopyWithImpl;
@useResult
$Res call({
 bool text, String content, int size, String? media, String? reason
});




}
/// @nodoc
class _$FilePreviewCopyWithImpl<$Res>
    implements $FilePreviewCopyWith<$Res> {
  _$FilePreviewCopyWithImpl(this._self, this._then);

  final FilePreview _self;
  final $Res Function(FilePreview) _then;

/// Create a copy of FilePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? content = null,Object? size = null,Object? media = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilePreview].
extension FilePreviewPatterns on FilePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilePreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilePreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilePreview value)  $default,){
final _that = this;
switch (_that) {
case _FilePreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilePreview value)?  $default,){
final _that = this;
switch (_that) {
case _FilePreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool text,  String content,  int size,  String? media,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilePreview() when $default != null:
return $default(_that.text,_that.content,_that.size,_that.media,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool text,  String content,  int size,  String? media,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _FilePreview():
return $default(_that.text,_that.content,_that.size,_that.media,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool text,  String content,  int size,  String? media,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _FilePreview() when $default != null:
return $default(_that.text,_that.content,_that.size,_that.media,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilePreview implements FilePreview {
  const _FilePreview({this.text = false, this.content = '', this.size = 0, this.media, this.reason});
  factory _FilePreview.fromJson(Map<String, dynamic> json) => _$FilePreviewFromJson(json);

@override@JsonKey() final  bool text;
@override@JsonKey() final  String content;
@override@JsonKey() final  int size;
/// `image` or `video` when the file can be displayed directly.
@override final  String? media;
@override final  String? reason;

/// Create a copy of FilePreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilePreviewCopyWith<_FilePreview> get copyWith => __$FilePreviewCopyWithImpl<_FilePreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilePreviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilePreview&&(identical(other.text, text) || other.text == text)&&(identical(other.content, content) || other.content == content)&&(identical(other.size, size) || other.size == size)&&(identical(other.media, media) || other.media == media)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,content,size,media,reason);

@override
String toString() {
  return 'FilePreview(text: $text, content: $content, size: $size, media: $media, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$FilePreviewCopyWith<$Res> implements $FilePreviewCopyWith<$Res> {
  factory _$FilePreviewCopyWith(_FilePreview value, $Res Function(_FilePreview) _then) = __$FilePreviewCopyWithImpl;
@override @useResult
$Res call({
 bool text, String content, int size, String? media, String? reason
});




}
/// @nodoc
class __$FilePreviewCopyWithImpl<$Res>
    implements _$FilePreviewCopyWith<$Res> {
  __$FilePreviewCopyWithImpl(this._self, this._then);

  final _FilePreview _self;
  final $Res Function(_FilePreview) _then;

/// Create a copy of FilePreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? content = null,Object? size = null,Object? media = freezed,Object? reason = freezed,}) {
  return _then(_FilePreview(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FileRootsResponse {

 bool get ok; List<FileRoot> get roots;
/// Create a copy of FileRootsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileRootsResponseCopyWith<FileRootsResponse> get copyWith => _$FileRootsResponseCopyWithImpl<FileRootsResponse>(this as FileRootsResponse, _$identity);

  /// Serializes this FileRootsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileRootsResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.roots, roots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(roots));

@override
String toString() {
  return 'FileRootsResponse(ok: $ok, roots: $roots)';
}


}

/// @nodoc
abstract mixin class $FileRootsResponseCopyWith<$Res>  {
  factory $FileRootsResponseCopyWith(FileRootsResponse value, $Res Function(FileRootsResponse) _then) = _$FileRootsResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, List<FileRoot> roots
});




}
/// @nodoc
class _$FileRootsResponseCopyWithImpl<$Res>
    implements $FileRootsResponseCopyWith<$Res> {
  _$FileRootsResponseCopyWithImpl(this._self, this._then);

  final FileRootsResponse _self;
  final $Res Function(FileRootsResponse) _then;

/// Create a copy of FileRootsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? roots = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as List<FileRoot>,
  ));
}

}


/// Adds pattern-matching-related methods to [FileRootsResponse].
extension FileRootsResponsePatterns on FileRootsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileRootsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileRootsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileRootsResponse value)  $default,){
final _that = this;
switch (_that) {
case _FileRootsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileRootsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FileRootsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  List<FileRoot> roots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileRootsResponse() when $default != null:
return $default(_that.ok,_that.roots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  List<FileRoot> roots)  $default,) {final _that = this;
switch (_that) {
case _FileRootsResponse():
return $default(_that.ok,_that.roots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  List<FileRoot> roots)?  $default,) {final _that = this;
switch (_that) {
case _FileRootsResponse() when $default != null:
return $default(_that.ok,_that.roots);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileRootsResponse implements FileRootsResponse {
  const _FileRootsResponse({required this.ok, final  List<FileRoot> roots = const []}): _roots = roots;
  factory _FileRootsResponse.fromJson(Map<String, dynamic> json) => _$FileRootsResponseFromJson(json);

@override final  bool ok;
 final  List<FileRoot> _roots;
@override@JsonKey() List<FileRoot> get roots {
  if (_roots is EqualUnmodifiableListView) return _roots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roots);
}


/// Create a copy of FileRootsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileRootsResponseCopyWith<_FileRootsResponse> get copyWith => __$FileRootsResponseCopyWithImpl<_FileRootsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileRootsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileRootsResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._roots, _roots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_roots));

@override
String toString() {
  return 'FileRootsResponse(ok: $ok, roots: $roots)';
}


}

/// @nodoc
abstract mixin class _$FileRootsResponseCopyWith<$Res> implements $FileRootsResponseCopyWith<$Res> {
  factory _$FileRootsResponseCopyWith(_FileRootsResponse value, $Res Function(_FileRootsResponse) _then) = __$FileRootsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, List<FileRoot> roots
});




}
/// @nodoc
class __$FileRootsResponseCopyWithImpl<$Res>
    implements _$FileRootsResponseCopyWith<$Res> {
  __$FileRootsResponseCopyWithImpl(this._self, this._then);

  final _FileRootsResponse _self;
  final $Res Function(_FileRootsResponse) _then;

/// Create a copy of FileRootsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? roots = null,}) {
  return _then(_FileRootsResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,roots: null == roots ? _self._roots : roots // ignore: cast_nullable_to_non_nullable
as List<FileRoot>,
  ));
}


}


/// @nodoc
mixin _$FileListResponse {

 bool get ok; FileListing get listing;
/// Create a copy of FileListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileListResponseCopyWith<FileListResponse> get copyWith => _$FileListResponseCopyWithImpl<FileListResponse>(this as FileListResponse, _$identity);

  /// Serializes this FileListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileListResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.listing, listing) || other.listing == listing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,listing);

@override
String toString() {
  return 'FileListResponse(ok: $ok, listing: $listing)';
}


}

/// @nodoc
abstract mixin class $FileListResponseCopyWith<$Res>  {
  factory $FileListResponseCopyWith(FileListResponse value, $Res Function(FileListResponse) _then) = _$FileListResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, FileListing listing
});


$FileListingCopyWith<$Res> get listing;

}
/// @nodoc
class _$FileListResponseCopyWithImpl<$Res>
    implements $FileListResponseCopyWith<$Res> {
  _$FileListResponseCopyWithImpl(this._self, this._then);

  final FileListResponse _self;
  final $Res Function(FileListResponse) _then;

/// Create a copy of FileListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? listing = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,listing: null == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as FileListing,
  ));
}
/// Create a copy of FileListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileListingCopyWith<$Res> get listing {
  
  return $FileListingCopyWith<$Res>(_self.listing, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}


/// Adds pattern-matching-related methods to [FileListResponse].
extension FileListResponsePatterns on FileListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileListResponse value)  $default,){
final _that = this;
switch (_that) {
case _FileListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FileListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  FileListing listing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileListResponse() when $default != null:
return $default(_that.ok,_that.listing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  FileListing listing)  $default,) {final _that = this;
switch (_that) {
case _FileListResponse():
return $default(_that.ok,_that.listing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  FileListing listing)?  $default,) {final _that = this;
switch (_that) {
case _FileListResponse() when $default != null:
return $default(_that.ok,_that.listing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileListResponse implements FileListResponse {
  const _FileListResponse({required this.ok, required this.listing});
  factory _FileListResponse.fromJson(Map<String, dynamic> json) => _$FileListResponseFromJson(json);

@override final  bool ok;
@override final  FileListing listing;

/// Create a copy of FileListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileListResponseCopyWith<_FileListResponse> get copyWith => __$FileListResponseCopyWithImpl<_FileListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileListResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.listing, listing) || other.listing == listing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,listing);

@override
String toString() {
  return 'FileListResponse(ok: $ok, listing: $listing)';
}


}

/// @nodoc
abstract mixin class _$FileListResponseCopyWith<$Res> implements $FileListResponseCopyWith<$Res> {
  factory _$FileListResponseCopyWith(_FileListResponse value, $Res Function(_FileListResponse) _then) = __$FileListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, FileListing listing
});


@override $FileListingCopyWith<$Res> get listing;

}
/// @nodoc
class __$FileListResponseCopyWithImpl<$Res>
    implements _$FileListResponseCopyWith<$Res> {
  __$FileListResponseCopyWithImpl(this._self, this._then);

  final _FileListResponse _self;
  final $Res Function(_FileListResponse) _then;

/// Create a copy of FileListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? listing = null,}) {
  return _then(_FileListResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,listing: null == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as FileListing,
  ));
}

/// Create a copy of FileListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileListingCopyWith<$Res> get listing {
  
  return $FileListingCopyWith<$Res>(_self.listing, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}

// dart format on
