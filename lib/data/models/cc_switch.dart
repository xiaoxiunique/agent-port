import 'package:freezed_annotation/freezed_annotation.dart';

part 'cc_switch.freezed.dart';
part 'cc_switch.g.dart';

/// A single API provider for Claude or Codex, surfaced by `GET /api/cc-switch`.
@freezed
abstract class CcSwitchProvider with _$CcSwitchProvider {
  const factory CcSwitchProvider({
    required String id,
    required String appType,
    required String name,
    required bool isCurrent,
    String? baseUrl,
    required bool hasApiKey,
  }) = _CcSwitchProvider;

  factory CcSwitchProvider.fromJson(Map<String, dynamic> json) =>
      _$CcSwitchProviderFromJson(json);
}

/// A provider group (claude or codex) with its available providers.
@freezed
abstract class CcSwitchApp with _$CcSwitchApp {
  const factory CcSwitchApp({
    required String appType,
    required String title,
    String? activeProviderId,
    @Default([]) List<CcSwitchProvider> providers,
  }) = _CcSwitchApp;

  factory CcSwitchApp.fromJson(Map<String, dynamic> json) =>
      _$CcSwitchAppFromJson(json);
}

@freezed
abstract class CcSwitchStatusResponse with _$CcSwitchStatusResponse {
  const factory CcSwitchStatusResponse({
    required bool ok,
    @Default([]) List<CcSwitchApp> apps,
  }) = _CcSwitchStatusResponse;

  factory CcSwitchStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$CcSwitchStatusResponseFromJson(json);
}
