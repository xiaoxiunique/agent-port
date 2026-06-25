import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/models/snapshot.dart';
import 'api_provider.dart';

/// Live snapshot stream over `/ws`, falling back to HTTP polling when the
/// socket drops, with periodic reconnection attempts. Mirrors the connection
/// state machine of the native `MonitorStore`.
class SnapshotNotifier extends Notifier<AsyncValue<Snapshot>> {
  WebSocketChannel? _socket;
  Timer? _pollTimer;
  Timer? _reconnectTimer;
  bool _disposed = false;

  @override
  AsyncValue<Snapshot> build() {
    // Reset on every (re)build — the Notifier instance is reused when
    // apiProvider changes, and onDispose sets _disposed = true.
    _disposed = false;
    ref.watch(apiProvider); // rebuild when the active profile changes
    ref.onDispose(_dispose);
    _connect();
    return const AsyncValue.loading();
  }

  void _connect() {
    final api = ref.read(apiProvider);
    try {
      _socket = WebSocketChannel.connect(api.wsUri('/ws'));
    } catch (_) {
      _startPolling();
      _scheduleReconnect();
      return;
    }
    _socket!.stream.listen(
      _onData,
      onError: (_) => _onClosed(),
      onDone: _onClosed,
    );
  }

  void _onData(dynamic message) {
    // Socket is alive — polling is not needed while we receive frames.
    _pollTimer?.cancel();
    _pollTimer = null;
    try {
      final decoded = jsonDecode(message as String) as Map<String, dynamic>;
      final snapJson =
          (decoded['snapshot'] as Map<String, dynamic>?) ?? decoded;
      if (!_disposed) state = AsyncValue.data(Snapshot.fromJson(snapJson));
    } catch (_) {
      // Ignore malformed frames; the next frame retries.
    }
  }

  void _onClosed() {
    _socket = null;
    _startPolling();
    _scheduleReconnect();
  }

  void _startPolling() {
    if (_pollTimer != null || _disposed) return;
    _pollOnce();
    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 2500),
      (_) => _pollOnce(),
    );
  }

  Future<void> _pollOnce() async {
    if (_disposed) return;
    try {
      final snap = await ref.read(apiProvider).snapshot();
      if (!_disposed) state = AsyncValue.data(snap);
    } catch (_) {
      // Keep last good state; polling retries on the next tick.
    }
  }

  /// Force an immediate snapshot fetch (e.g. pull-to-refresh). Awaitable so the
  /// caller can drive a [RefreshIndicator]; leaves the socket/poll machinery
  /// untouched.
  Future<void> refresh() => _pollOnce();

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (_disposed) return;
      _pollTimer?.cancel();
      _pollTimer = null;
      _connect();
    });
  }

  void _dispose() {
    _disposed = true;
    _pollTimer?.cancel();
    _reconnectTimer?.cancel();
    _socket?.sink.close();
    _socket = null;
  }
}

final snapshotProvider =
    NotifierProvider<SnapshotNotifier, AsyncValue<Snapshot>>(
  SnapshotNotifier.new,
);
