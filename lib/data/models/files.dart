import 'package:freezed_annotation/freezed_annotation.dart';

part 'files.freezed.dart';
part 'files.g.dart';

/// A directory the client is allowed to browse, from `GET /api/files/roots`.
///
/// The host derives these from the project directories it already knows (live
/// pane cwds plus project history) and refuses anything outside them, so the
/// client never has to guess what's reachable.
@freezed
abstract class FileRoot with _$FileRoot {
  const factory FileRoot({
    required String path,
    required String name,
  }) = _FileRoot;

  factory FileRoot.fromJson(Map<String, dynamic> json) =>
      _$FileRootFromJson(json);
}

/// One entry in a directory listing.
@freezed
abstract class FileEntry with _$FileEntry {
  const factory FileEntry({
    required String name,
    required String path,
    required bool isDir,
    @Default(0) int size,

    /// Seconds since the epoch; absent when the platform won't report it.
    double? modified,
  }) = _FileEntry;

  factory FileEntry.fromJson(Map<String, dynamic> json) =>
      _$FileEntryFromJson(json);
}

/// A directory's contents, from `GET /api/files/list`.
@freezed
abstract class FileListing with _$FileListing {
  const factory FileListing({
    required String path,

    /// The root this path sits under. Navigation stops here rather than
    /// walking up into a path the host would reject.
    required String root,
    @Default([]) List<FileEntry> entries,

    /// True when noise directories (.git, node_modules, …) and dotfiles were
    /// hidden.
    @Default(true) bool filtered,
  }) = _FileListing;

  factory FileListing.fromJson(Map<String, dynamic> json) =>
      _$FileListingFromJson(json);
}

/// Result of `GET /api/files/read`.
///
/// Three outcomes: `text` true carries the content inline; `media` set to
/// `image` or `video` means render it from the download URL instead (which
/// serves the right content type); neither means download-only.
@freezed
abstract class FilePreview with _$FilePreview {
  const factory FilePreview({
    @Default(false) bool text,
    @Default('') String content,
    @Default(0) int size,

    /// `image` or `video` when the file can be displayed directly.
    String? media,
    String? reason,
  }) = _FilePreview;

  factory FilePreview.fromJson(Map<String, dynamic> json) =>
      _$FilePreviewFromJson(json);
}

@freezed
abstract class FileRootsResponse with _$FileRootsResponse {
  const factory FileRootsResponse({
    required bool ok,
    @Default([]) List<FileRoot> roots,
  }) = _FileRootsResponse;

  factory FileRootsResponse.fromJson(Map<String, dynamic> json) =>
      _$FileRootsResponseFromJson(json);
}

@freezed
abstract class FileListResponse with _$FileListResponse {
  const factory FileListResponse({
    required bool ok,
    required FileListing listing,
  }) = _FileListResponse;

  factory FileListResponse.fromJson(Map<String, dynamic> json) =>
      _$FileListResponseFromJson(json);
}
