import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bridges the macOS Screen Recording permission (needed by the control-center
/// screenshot / window-preview features). All methods are no-ops off macOS.
class PermissionService {
  static const _channel = MethodChannel('agent_port/permissions');

  bool get _supported => !kIsWeb && Platform.isMacOS;

  /// Non-prompting status check (`CGPreflightScreenCaptureAccess`).
  Future<bool> screenRecordingGranted() async {
    if (!_supported) return true;
    try {
      return await _channel.invokeMethod<bool>('screenRecordingStatus') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Triggers the system prompt the first time (`CGRequestScreenCaptureAccess`).
  Future<bool> requestScreenRecording() async {
    if (!_supported) return true;
    try {
      return await _channel.invokeMethod<bool>('requestScreenRecording') ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Open System Settings → Privacy & Security → Screen Recording.
  Future<void> openScreenRecordingSettings() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod<void>('openScreenRecordingSettings');
    } catch (_) {}
  }
}

final permissionServiceProvider =
    Provider<PermissionService>((_) => PermissionService());

/// Holds the current Screen Recording grant state for the host UI. Starts as
/// `false` (unknown) and self-corrects on the first async check.
class ScreenRecordingNotifier extends Notifier<bool> {
  @override
  bool build() {
    _check();
    return false;
  }

  Future<void> _check() async {
    final granted =
        await ref.read(permissionServiceProvider).screenRecordingGranted();
    state = granted;
  }

  /// Re-query the current status (e.g. after returning from System Settings).
  Future<void> refresh() => _check();

  /// Prompt for access, then refresh the status.
  Future<void> request() async {
    await ref.read(permissionServiceProvider).requestScreenRecording();
    await _check();
  }

  Future<void> openSettings() =>
      ref.read(permissionServiceProvider).openScreenRecordingSettings();
}

final screenRecordingProvider =
    NotifierProvider<ScreenRecordingNotifier, bool>(ScreenRecordingNotifier.new);
