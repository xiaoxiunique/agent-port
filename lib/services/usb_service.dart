import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/usb_device.dart';
import 'api_provider.dart';
import 'demo_data.dart';

/// USB devices physically connected to the host.
final usbDevicesProvider =
    FutureProvider.autoDispose<UsbDevicesResponse>((ref) async {
  if (ref.watch(demoModeProvider)) {
    return const UsbDevicesResponse(ok: true, available: true);
  }
  return ref.watch(apiProvider).usbDevices();
});
