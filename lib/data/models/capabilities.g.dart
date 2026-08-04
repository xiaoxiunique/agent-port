// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HerdrCapability _$HerdrCapabilityFromJson(Map<String, dynamic> json) =>
    _HerdrCapability(
      installed: json['installed'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? false,
    );

Map<String, dynamic> _$HerdrCapabilityToJson(_HerdrCapability instance) =>
    <String, dynamic>{
      'installed': instance.installed,
      'enabled': instance.enabled,
    };

_Capabilities _$CapabilitiesFromJson(Map<String, dynamic> json) =>
    _Capabilities(
      cronbox: json['cronbox'] as bool? ?? false,
      ccSwitch: json['ccSwitch'] as bool? ?? false,
      herdr: json['herdr'] == null
          ? const HerdrCapability()
          : HerdrCapability.fromJson(json['herdr'] as Map<String, dynamic>),
      full: json['full'] as bool? ?? false,
      platform: json['platform'] as String? ?? '',
    );

Map<String, dynamic> _$CapabilitiesToJson(_Capabilities instance) =>
    <String, dynamic>{
      'cronbox': instance.cronbox,
      'ccSwitch': instance.ccSwitch,
      'herdr': instance.herdr,
      'full': instance.full,
      'platform': instance.platform,
    };

_CapabilitiesResponse _$CapabilitiesResponseFromJson(
  Map<String, dynamic> json,
) => _CapabilitiesResponse(
  ok: json['ok'] as bool,
  capabilities: json['capabilities'] == null
      ? const Capabilities()
      : Capabilities.fromJson(json['capabilities'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CapabilitiesResponseToJson(
  _CapabilitiesResponse instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'capabilities': instance.capabilities,
};
