import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/agent_monitor_api.dart';
import '../../data/models/server_profile.dart';
import '../../services/settings_service.dart';
import '../settings/settings_view.dart' show ServerEditPage;
import 'scan_qr_page.dart';

/// Normalize a scanned string into an http(s) URL. A bare `ip` or `ip:port`
/// gets an `http://` prefix. Returns null if it doesn't look like a server
/// address (so callers can reject an unrelated QR).
String? normalizeScannedUrl(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return null;
  if (!s.contains('://')) s = 'http://$s';
  final u = Uri.tryParse(s);
  if (u == null || u.host.isEmpty) return null;
  return s;
}

/// Open the scanner, then try to connect to the scanned address automatically.
///
/// On success the profile is added and made active (and onboarding is completed
/// when [fromOnboarding]). On failure — e.g. the server needs a token — it falls
/// back to the prefilled add-server form so the user can finish by hand.
Future<void> scanAndAddServer(
  BuildContext context,
  WidgetRef ref, {
  bool fromOnboarding = false,
}) async {
  final notifier = ref.read(settingsProvider.notifier);

  final raw = await Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (_) => const ScanQrPage()),
  );
  if (raw == null || !context.mounted) return;

  final url = normalizeScannedUrl(raw);
  if (url == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('二维码不是有效的服务地址')),
    );
    return;
  }

  // Auto-connect probe behind a small blocking spinner.
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  bool ok = false;
  try {
    final snap = await AgentMonitorApi(baseUrl: url)
        .snapshot()
        .timeout(const Duration(seconds: 8));
    ok = snap.ok;
  } catch (_) {
    ok = false;
  }
  if (context.mounted) Navigator.of(context).pop(); // dismiss spinner

  if (ok) {
    final profile = ServerProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: Uri.parse(url).host,
      url: url,
    );
    await notifier.addProfile(profile);
    await notifier.setActive(profile.id);
    if (fromOnboarding) await notifier.completeOnboarding();
    return;
  }

  // Auto-connect failed → let the user finish in the prefilled form.
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ServerEditPage(initialUrl: url)),
  );
  // If this was first-run onboarding and the user did save a profile in the
  // form, leave onboarding so they land on the monitor instead of bouncing back.
  if (fromOnboarding &&
      (ref.read(settingsProvider).valueOrNull?.profiles.isNotEmpty ?? false)) {
    await notifier.completeOnboarding();
  }
}
