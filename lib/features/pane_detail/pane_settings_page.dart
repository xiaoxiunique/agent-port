import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notify_config.dart';
import '../../data/models/pane.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';

/// Per-session push-notification settings (P3). Reached from the detail page's
/// top-right button. Keyed server-side by [Pane.path] (the project dir), so the
/// config sticks to the project even as tmux pane ids change.
///
/// Push only fires for turns kicked off from a phone and then left — see the
/// note at the bottom of the page.
class PaneSettingsPage extends ConsumerStatefulWidget {
  const PaneSettingsPage({super.key, required this.pane});

  final Pane pane;

  @override
  ConsumerState<PaneSettingsPage> createState() => _PaneSettingsPageState();
}

class _PaneSettingsPageState extends ConsumerState<PaneSettingsPage> {
  NotifyConfig? _cfg;
  bool _loading = true;
  String? _error;
  bool _demo = false;

  String get _key => widget.pane.path;

  String get _project {
    final parts = widget.pane.path.split('/').where((s) => s.isNotEmpty);
    return parts.isEmpty ? widget.pane.path : parts.last;
  }

  @override
  void initState() {
    super.initState();
    _demo = ref.read(demoModeProvider);
    _load();
  }

  Future<void> _load() async {
    if (_demo) {
      setState(() {
        _cfg = const NotifyConfig.off();
        _loading = false;
      });
      return;
    }
    try {
      final cfg = await ref.read(apiProvider).getNotifyConfig(_key);
      if (mounted) {
        setState(() {
          _cfg = cfg;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '$e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _save(NotifyConfig next) async {
    setState(() => _cfg = next); // optimistic
    if (_demo) return;
    try {
      await ref.read(apiProvider).setNotifyConfig(_key, next.enabled, next.events);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    }
  }

  void _toggleEvent(String event, bool on) {
    final events = [..._cfg!.events];
    if (on) {
      if (!events.contains(event)) events.add(event);
    } else {
      events.remove(event);
    }
    _save(_cfg!.copyWith(events: events));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('通知设置')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('读取失败：$_error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).hintColor)),
        ),
      );
    }
    final cfg = _cfg!;
    final hint = Theme.of(context).hintColor;
    return ListView(
      children: [
        if (widget.pane.path.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text('此会话没有项目路径，无法保存通知设置。',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(_project,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        SwitchListTile(
          title: const Text('接收此会话通知'),
          subtitle: const Text('Claude 完成 / 需要确认时推送到手机'),
          value: cfg.enabled,
          onChanged: widget.pane.path.isEmpty
              ? null
              : (v) => _save(cfg.copyWith(enabled: v)),
        ),
        const Divider(height: 1),
        CheckboxListTile(
          title: const Text('需要确认'),
          subtitle: const Text('Claude 卡在 y/n 确认时'),
          value: cfg.waiting,
          onChanged: cfg.enabled ? (v) => _toggleEvent('waiting', v ?? false) : null,
        ),
        CheckboxListTile(
          title: const Text('任务完成'),
          subtitle: const Text('Claude 跑完、回到空闲时'),
          value: cfg.done,
          onChanged: cfg.enabled ? (v) => _toggleEvent('done', v ?? false) : null,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            _demo
                ? '演示模式：设置不会保存。'
                : '只有你从手机发起、然后离开的那一轮才会推送；'
                    '你在电脑前直接操作（终端或电脑版）不会推送。',
            style: TextStyle(fontSize: 12, color: hint),
          ),
        ),
      ],
    );
  }
}
