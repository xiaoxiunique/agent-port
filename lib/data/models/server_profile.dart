import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_profile.freezed.dart';
part 'server_profile.g.dart';

/// One Agent Monitor server connection. Mirrors iOS `ServerProfile`.
@freezed
abstract class ServerProfile with _$ServerProfile {
  const factory ServerProfile({
    required String id,
    required String name,
    required String url,
    String? token,
  }) = _ServerProfile;

  factory ServerProfile.fromJson(Map<String, dynamic> json) =>
      _$ServerProfileFromJson(json);
}
