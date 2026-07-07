import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/models/snapshot.dart';
import 'api_provider.dart';
import 'demo_data.dart';

/// Live snapshot stream over `/ws`, falling back to HTTP polling when the
/// socket drops, with periodic reconnection attempts. Mirrors the connection
/// state machine of the native `MonitorStore`.
class SnapshotNotifier extends Notifier<AsyncValue<Snapshot>> {
  WebSocketChannel? _socket;
  StreamSubscription? _sub;
  Timer? _pollTimer;
  Timer? _reconnectTimer;
  bool _disposed = false;

  @override
  AsyncValue<Snapshot> build() {
    // Reset on every (re)build — the Notifier instance is reused when
    // apiProvider changes, and onDispose sets _disposed = true.
    _disposed = false;
    ref.onDispose(_dispose);
    // Demo mode: serve offline sample data, no socket/polling.
    if (ref.watch(demoModeProvider)) {
      return AsyncValue.data(demoSnapshot());
    }
    ref.watch(apiProvider); // rebuild when the active profile changes
    _connect();
    return const AsyncValue.loading();
  }

  void _connect() {
    // Fully tear down any previous socket first. Switching profiles reuses this
    // notifier instance and resets `_disposed`, so a stale server's still-open
    // stream would keep pushing frames into `state` and make the list flip-flop
    // between the two servers. Cancelling the subscription (not just closing the
    // sink) guarantees the old socket's callbacks can never fire again.
    _sub?.cancel();
    _sub = null;
    _socket?.sink.close();
    _socket = null;
    final api = ref.read(apiProvider);
    try {
      _socket = WebSocketChannel.connect(api.wsUri('/ws'));
    } catch (_) {
      _startPolling();
      _scheduleReconnect();
      return;
    }
    _sub = _socket!.stream.listen(
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
    _sub?.cancel();
    _sub = null;
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
    _sub?.cancel();
    _sub = null;
    _socket?.sink.close();
    _socket = null;
  }
}

final snapshotProvider =
    NotifierProvider<SnapshotNotifier, AsyncValue<Snapshot>>(
  SnapshotNotifier.new,
);
