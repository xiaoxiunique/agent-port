import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/files.dart';
import 'api_provider.dart';
import 'demo_data.dart';

/// Directories the host allows browsing. Refetched when the profile changes.
final fileRootsProvider = FutureProvider.autoDispose<List<FileRoot>>((ref) async {
  if (ref.watch(demoModeProvider)) return const [];
  return ref.watch(apiProvider).fileRoots();
});

/// Arguments for one directory listing. A record rather than a bare path so
/// the "show hidden" toggle produces a distinct provider instance.
typedef FileListArgs = ({String path, bool showAll});

final fileListProvider = FutureProvider.autoDispose
    .family<FileListing, FileListArgs>((ref, args) async {
  if (ref.watch(demoModeProvider)) {
    return FileListing(path: args.path, root: args.path);
  }
  return ref.watch(apiProvider).fileList(args.path, showAll: args.showAll);
});

/// Inline text preview for one file.
final filePreviewProvider =
    FutureProvider.autoDispose.family<FilePreview, String>((ref, path) async {
  if (ref.watch(demoModeProvider)) return const FilePreview();
  return ref.watch(apiProvider).fileRead(path);
});
