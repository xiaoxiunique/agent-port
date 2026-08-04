// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usb_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsbDevice _$UsbDeviceFromJson(Map<String, dynamic> json) => _UsbDevice(
  product: json['product'] as String,
  vendor: json['vendor'] as String? ?? '',
  serial: json['serial'] as String?,
);

Map<String, dynamic> _$UsbDeviceToJson(_UsbDevice instance) =>
    <String, dynamic>{
      'product': instance.product,
      'vendor': instance.vendor,
      'serial': instance.serial,
    };

_UsbDevicesResponse _$UsbDevicesResponseFromJson(Map<String, dynamic> json) =>
    _UsbDevicesResponse(
      ok: json['ok'] as bool,
      available: json['available'] as bool? ?? false,
      devices:
          (json['devices'] as List<dynamic>?)
              ?.map((e) => UsbDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UsbDevicesResponseToJson(_UsbDevicesResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'available': instance.available,
      'devices': instance.devices,
    };
