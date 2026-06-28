import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_provider.dart';

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));

/// iOS push (P1): requests notification permission, obtains the APNs device
/// token from native code over the `agent_port/push` channel, and registers it
/// with the active server so the Rust service can deliver alerts. No-op on
/// non-iOS / web.
class PushService {
  PushService(this._ref);
  final Ref _ref;

  static const _channel = MethodChannel('agent_port/push');
  String? _token;

  /// Wire up the native→Dart token callback and ask for permission.
  Future<void> init() async {
    if (kIsWeb || !Platform.isIOS) return;
    _channel.setMethodCallHandler(_onCall);
    try {
      await _channel.invokeMethod<bool>('requestPermission');
      // The token may have arrived before the handler was attached.
      final existing = await _channel.invokeMethod<String>('getToken');
      if (existing != null && existing.isNotEmpty) {
        _token = existing;
        await _register(existing);
      }
    } catch (_) {
      // Push unavailable (e.g. simulator without APNs entitlement); ignore.
    }
  }

  /// Re-send the known token to the (possibly newly-selected) active server.
  Future<void> reregister() async {
    final token = _token;
    if (token != null) await _register(token);
  }

  Future<dynamic> _onCall(MethodCall call) async {
    if (call.method == 'onToken') {
      final token = call.arguments as String?;
      if (token != null && token.isNotEmpty) {
        _token = token;
        await _register(token);
      }
    }
    return null;
  }

  Future<void> _register(String token) async {
    try {
      await _ref.read(apiProvider).registerPushToken(token);
    } catch (_) {
      // Server unreachable; retries on next launch / token event / profile switch.
    }
  }
}
