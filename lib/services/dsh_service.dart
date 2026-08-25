import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_provider.dart';
import 'demo_data.dart';
import 'settings_service.dart';

/// Where the host relays the DeepSeek Harness UI, if anywhere.
///
/// dsh binds loopback only and refuses to do otherwise — its UI can run
/// arbitrary code — so `amux serve` relays it on a second port. The host
/// reports that port under `capabilities.dsh`, and the URL is built from it
/// plus the host we already talk to.
///
/// Read straight off the raw response rather than through the `Capabilities`
/// model: adding a field there needs a codegen run, which is currently broken.
class DshEndpoint {
  const DshEndpoint({
    this.available = false,
    this.url,
    this.viaNgrok = false,
  });

  /// A `dsh web` is running on the host.
  final bool available;

  /// Full URL to open in a WebView. Null when the relay isn't up, which
  /// happens if dsh started after the daemon did.
  final String? url;

  /// Whether [url] is an ngrok tunnel. Free tunnels answer a browser's first
  /// navigation with an interstitial instead of the page, unless the request
  /// carries `ngrok-skip-browser-warning`.
  final bool viaNgrok;

  bool get usable => available && url != null;
}

/// A URL typed in by hand, overriding whatever the host advertises.
///
/// The host can only report where *it* put the relay; whether this device can
/// reach that address is a different question, and one the host cannot answer.
/// A tailnet name that resolves on the Mac may be hijacked on the phone's
/// network, and a tunnel URL is not something the host knows about at all.
/// So the override is stored per device, not per server.
///
/// Kept out of `AppSettings` because that model is generated and a codegen run
/// currently fails on this toolchain.
class DshOverrideUrl extends AsyncNotifier<String> {
  static const _key = 'dsh_override_url';

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? '';
  }

  /// Save a URL, or clear the override with a blank one.
  Future<void> set(String url) async {
    final trimmed = url.trim();
    final prefs = await SharedPreferences.getInstance();
    if (trimmed.isEmpty) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, trimmed);
    }
    state = AsyncData(trimmed);
    // The endpoint is derived from this, so it has to be recomputed.
    ref.invalidate(dshEndpointProvider);
  }
}

final dshOverrideUrlProvider =
    AsyncNotifierProvider<DshOverrideUrl, String>(DshOverrideUrl.new);

final dshEndpointProvider = FutureProvider<DshEndpoint>((ref) async {
  if (ref.watch(demoModeProvider)) return const DshEndpoint();

  // A hand-entered URL wins over discovery, and is trusted even when the host
  // reports no dsh at all — the point of typing one is to reach something the
  // host could not tell us about.
  final override = ref.watch(dshOverrideUrlProvider).valueOrNull ?? '';
  if (override.isNotEmpty) {
    return DshEndpoint(available: true, url: override);
  }

  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings == null) return const DshEndpoint();
  final profile = settings.profiles
      .where((p) => p.id == settings.activeProfileId)
      .firstOrNull;
  if (profile == null) return const DshEndpoint();

  try {
    final api = ref.watch(apiProvider);
    final raw = await api.rawCapabilities();
    final dsh = raw['dsh'];
    if (dsh is! Map) return const DshEndpoint();

    final available = dsh['available'] == true;
    final port = (dsh['relayPort'] as num?)?.toInt();
    if (!available || port == null) return DshEndpoint(available: available);

    // Same host, different port. The scheme comes from the host: browsers
    // only allow a WebSocket from a plain-HTTP page on loopback, so off this
    // machine the relay has to be HTTPS and dsh's UI would otherwise load
    // but never populate.
    // A public tunnel wins when the host has one: it resolves through public
    // DNS, so it works on networks where the tailnet name does not — which is
    // exactly the case this app kept failing in.
    final publicUrl = (dsh['publicUrl'] as String?)?.trim();
    if (publicUrl != null && publicUrl.isNotEmpty) {
      return DshEndpoint(available: true, url: publicUrl, viaNgrok: true);
    }

    final base = Uri.parse(profile.url);
    final tls = dsh['relayTls'] == true;
    // Over TLS the certificate is issued for a name, so the host reports which
    // one; using the address the API happens to live at would fail the
    // handshake. Falls back to that address when there is no certificate.
    final certHost = (dsh['relayHost'] as String?)?.trim();
    final host = (tls && certHost != null && certHost.isNotEmpty)
        ? certHost
        : base.host;
    final url = Uri(scheme: tls ? 'https' : 'http', host: host, port: port)
        .toString();
    return DshEndpoint(available: true, url: url);
  } on DioException {
    return const DshEndpoint();
  } catch (_) {
    return const DshEndpoint();
  }
});
