import 'package:freezed_annotation/freezed_annotation.dart';

part 'capabilities.freezed.dart';
part 'capabilities.g.dart';

/// Whether herdr is present, and whether the bridge is actually on.
///
/// The two differ in a way that matters to the UI: not installed means hide
/// the feature, while installed-but-disabled is actionable — the user needs to
/// restart the service with `--herdr`.
@freezed
abstract class HerdrCapability with _$HerdrCapability {
  const factory HerdrCapability({
    @Default(false) bool installed,
    @Default(false) bool enabled,
  }) = _HerdrCapability;

  factory HerdrCapability.fromJson(Map<String, dynamic> json) =>
      _$HerdrCapabilityFromJson(json);
}

/// Which optional tools the host machine has, from `GET /api/capabilities`.
///
/// Lets the client hide features it can't use instead of discovering they're
/// missing by calling them and handling the failure.
@freezed
abstract class Capabilities with _$Capabilities {
  const factory Capabilities({
    /// CronBox is installed — the scheduled-jobs screen has something to show.
    @Default(false) bool cronbox,

    /// CC Switch is installed — provider switching is available.
    @Default(false) bool ccSwitch,

    @Default(HerdrCapability()) HerdrCapability herdr,

    /// The service was built with `--features full`: control center,
    /// screenshots, app list and push endpoints exist.
    @Default(false) bool full,

    /// Host OS (`macos`, `linux`, `windows`).
    @Default('') String platform,
  }) = _Capabilities;

  factory Capabilities.fromJson(Map<String, dynamic> json) =>
      _$CapabilitiesFromJson(json);
}

@freezed
abstract class CapabilitiesResponse with _$CapabilitiesResponse {
  const factory CapabilitiesResponse({
    required bool ok,
    @Default(Capabilities()) Capabilities capabilities,
  }) = _CapabilitiesResponse;

  factory CapabilitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$CapabilitiesResponseFromJson(json);
}
