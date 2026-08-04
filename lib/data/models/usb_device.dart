import 'package:freezed_annotation/freezed_annotation.dart';

part 'usb_device.freezed.dart';
part 'usb_device.g.dart';

/// A USB device physically connected to the host, from `GET /api/usb/devices`.
@freezed
abstract class UsbDevice with _$UsbDevice {
  const factory UsbDevice({
    required String product,

    /// e.g. "Xiaomi", "Apple Inc."
    @Default('') String vendor,

    /// USB serial; absent when the device doesn't report one.
    String? serial,
  }) = _UsbDevice;

  factory UsbDevice.fromJson(Map<String, dynamic> json) =>
      _$UsbDeviceFromJson(json);
}

@freezed
abstract class UsbDevicesResponse with _$UsbDevicesResponse {
  const factory UsbDevicesResponse({
    required bool ok,

    /// Always false on non-macOS hosts — `ioreg` only exists there.
    @Default(false) bool available,
    @Default([]) List<UsbDevice> devices,
  }) = _UsbDevicesResponse;

  factory UsbDevicesResponse.fromJson(Map<String, dynamic> json) =>
      _$UsbDevicesResponseFromJson(json);
}
