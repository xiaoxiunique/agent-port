import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const DshEndpoint({this.available = false, this.url});

  /// A `dsh web` is running on the host.
  final bool available;

  /// Full URL to open in a WebView. Null when the relay isn't up, which
  /// happens if dsh started after the daemon did.
  final String? url;

  bool get usable => available && url != null;
}

final dshEndpointProvider = FutureProvider<DshEndpoint>((ref) async {
  if (ref.watch(demoModeProvider)) return const DshEndpoint();

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
