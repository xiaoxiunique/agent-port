import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router.dart';
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
      // Cold start: the app may have been launched by tapping a notification.
      final tapped = await _channel.invokeMethod<String>('getPendingTap');
      if (tapped != null && tapped.isNotEmpty) _navigate(tapped);
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
    switch (call.method) {
      case 'onToken':
        final token = call.arguments as String?;
        if (token != null && token.isNotEmpty) {
          _token = token;
          await _register(token);
        }
      case 'onTap':
        final paneId = call.arguments as String?;
        if (paneId != null) _navigate(paneId);
    }
    return null;
  }

  /// Deep-link to a pane's detail page when its notification is tapped.
  void _navigate(String paneId) {
    if (paneId.isEmpty) return;
    _ref.read(routerProvider).push('/pane/${Uri.encodeComponent(paneId)}');
  }

  Future<void> _register(String token) async {
    try {
      await _ref.read(apiProvider).registerPushToken(token);
    } catch (_) {
      // Server unreachable; retries on next launch / token event / profile switch.
    }
  }
}
