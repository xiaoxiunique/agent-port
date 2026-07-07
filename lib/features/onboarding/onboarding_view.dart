import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/agent_monitor_api.dart';
import '../../data/models/server_profile.dart';
import '../../services/settings_service.dart';
import 'scan_add_flow.dart';

/// First-run setup: enter a server URL (+ optional token), test the
/// connection, then save as the first profile and complete onboarding.
class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _url = TextEditingController(text: 'http://127.0.0.1:8797');
  final _token = TextEditingController();
  bool _testing = false;
  bool _connected = false;
  String? _error;

  @override
  void dispose() {
    _url.dispose();
    _token.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    final url = _url.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _testing = true;
      _error = null;
      _connected = false;
    });
    try {
      final token = _token.text.trim();
      final api = AgentMonitorApi(
        baseUrl: url,
        token: token.isEmpty ? null : token,
      );
      final snap = await api.snapshot().timeout(const Duration(seconds: 8));
      setState(() => _connected = snap.ok);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _finish() async {
    final url = _url.text.trim();
    final token = _token.text.trim();
    final notifier = ref.read(settingsProvider.notifier);
    await notifier.addProfile(ServerProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _hostOf(url),
      url: url,
      token: token.isEmpty ? null : token,
    ));
    await notifier.completeOnboarding();
  }

  String _hostOf(String url) {
    try {
      return Uri.parse(url).host;
    } catch (_) {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('连接服务')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Agent Port', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('输入 Agent Monitor 服务地址(Rust 服务端)。',
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) ...[
                FilledButton.tonalIcon(
                  onPressed: () =>
                      scanAndAddServer(context, ref, fromOnboarding: true),
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('扫码连接 Mac'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('或手动填写',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _url,
                decoration: const InputDecoration(
                  labelText: '服务地址',
                  hintText: 'http://127.0.0.1:8797',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                autocorrect: false,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _token,
                decoration: const InputDecoration(
                  labelText: 'Token(可选)',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _testing ? null : _test,
                      child: _testing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('测试连接'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _connected ? _finish : null,
                      child: const Text('完成'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_connected)
                const Text('✓ 连接成功', style: TextStyle(color: Colors.green))
              else if (_error != null)
                Text('✗ $_error',
                    style: TextStyle(color: theme.colorScheme.error)),
            ],
          ),
        ),
      ),
    );
  }
}
