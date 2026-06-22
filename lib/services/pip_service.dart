import 'dart:io' show Platform;

import 'package:flutter/services.dart';

/// Picture-in-Picture for a pane's live log (iOS only).
///
/// Calls the native `agent_port/pip` method channel implemented in
/// `ios/Runner/AppDelegate.swift`, which renders the log tail into video
/// frames and drives `AVPictureInPictureController`.
class PipService {
  static const _channel = MethodChannel('agent_port/pip');

  /// PiP is only available on iOS; on other platforms this is always false.
  static Future<bool> get isSupported async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> start({
    required String title,
    required String status,
    required String body,
  }) async {
    if (!Platform.isIOS) return;
    await _channel.invokeMethod('start', {
      'title': title,
      'status': status,
      'body': body,
    });
  }

  static Future<void> update({
    required String title,
    required String status,
    required String body,
  }) async {
    if (!Platform.isIOS) return;
    await _channel.invokeMethod('update', {
      'title': title,
      'status': status,
      'body': body,
    });
  }

  static Future<void> stop() async {
    if (!Platform.isIOS) return;
    await _channel.invokeMethod('stop');
  }
}
