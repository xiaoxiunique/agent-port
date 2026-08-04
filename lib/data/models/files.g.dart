// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileRoot _$FileRootFromJson(Map<String, dynamic> json) =>
    _FileRoot(path: json['path'] as String, name: json['name'] as String);

Map<String, dynamic> _$FileRootToJson(_FileRoot instance) => <String, dynamic>{
  'path': instance.path,
  'name': instance.name,
};

_FileEntry _$FileEntryFromJson(Map<String, dynamic> json) => _FileEntry(
  name: json['name'] as String,
  path: json['path'] as String,
  isDir: json['isDir'] as bool,
  size: (json['size'] as num?)?.toInt() ?? 0,
  modified: (json['modified'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FileEntryToJson(_FileEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'isDir': instance.isDir,
      'size': instance.size,
      'modified': instance.modified,
    };

_FileListing _$FileListingFromJson(Map<String, dynamic> json) => _FileListing(
  path: json['path'] as String,
  root: json['root'] as String,
  entries:
      (json['entries'] as List<dynamic>?)
          ?.map((e) => FileEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  filtered: json['filtered'] as bool? ?? true,
);

Map<String, dynamic> _$FileListingToJson(_FileListing instance) =>
    <String, dynamic>{
      'path': instance.path,
      'root': instance.root,
      'entries': instance.entries,
      'filtered': instance.filtered,
    };

_FilePreview _$FilePreviewFromJson(Map<String, dynamic> json) => _FilePreview(
  text: json['text'] as bool? ?? false,
  content: json['content'] as String? ?? '',
  size: (json['size'] as num?)?.toInt() ?? 0,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$FilePreviewToJson(_FilePreview instance) =>
    <String, dynamic>{
      'text': instance.text,
      'content': instance.content,
      'size': instance.size,
      'reason': instance.reason,
    };

_FileRootsResponse _$FileRootsResponseFromJson(Map<String, dynamic> json) =>
    _FileRootsResponse(
      ok: json['ok'] as bool,
      roots:
          (json['roots'] as List<dynamic>?)
              ?.map((e) => FileRoot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FileRootsResponseToJson(_FileRootsResponse instance) =>
    <String, dynamic>{'ok': instance.ok, 'roots': instance.roots};

_FileListResponse _$FileListResponseFromJson(Map<String, dynamic> json) =>
    _FileListResponse(
      ok: json['ok'] as bool,
      listing: FileListing.fromJson(json['listing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileListResponseToJson(_FileListResponse instance) =>
    <String, dynamic>{'ok': instance.ok, 'listing': instance.listing};
