import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../data/models/session_timer.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
import '../../services/snapshot_service.dart';

/// Put one session on a timer: every so often, send it the same prompt.
///
/// The same two fields as the TUI's `T` form, and the same refusals — an empty
/// prompt or an interval that cannot be read will not arm. A schedule types at
/// an agent while nobody is watching, so a half-meant one is worse than none.
class SessionTimerPage extends ConsumerStatefulWidget {
  const SessionTimerPage({super.key, required this.pane});

  final Pane pane;

  @override
  ConsumerState<SessionTimerPage> createState() => _SessionTimerPageState();
}

class _SessionTimerPageState extends ConsumerState<SessionTimerPage> {
  late final TextEditingController _every;
  late final TextEditingController _prompt;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Seeded from whatever is already armed, so editing a schedule starts from
    // the current one rather than from a blank.
    final existing = ref.read(sessionTimersProvider)[widget.pane.session];
    _every = TextEditingController(
      text: existing == null ? '30m' : everyLabel(existing.everySecs),
    );
    _prompt = TextEditingController(text: existing?.prompt ?? '');
  }

  @override
  void dispose() {
    _every.dispose();
    _prompt.dispose();
    super.dispose();
  }

  void _say(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _arm() async {
    final prompt = _prompt.text.trim();
    final secs = parseEvery(_every.text);
    // Mirrors the TUI: refuse rather than arm on a guess, and leave what was
    // typed alone so it can be corrected.
    if (prompt.isEmpty) return _say('定时任务需要一条 prompt');
    if (secs == null) return _say('这个间隔读不懂');

    setState(() => _busy = true);
    try {
      await ref.read(apiProvider).timerEnable(
        session: widget.pane.session,
        prompt: prompt,
        everySecs: secs,
      );
      if (mounted) _say('已开启，每 ${everyLabel(secs)} 一次');
    } catch (e) {
      if (mounted) _say('没能保存：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disarm() async {
    setState(() => _busy = true);
    try {
      await ref.read(apiProvider).timerDisable(widget.pane.session);
      if (mounted) _say('已停止');
    } catch (e) {
      if (mounted) _say('没能停止：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(sessionTimersProvider)[widget.pane.session];
    final on = timer?.enabled ?? false;
    final hint = Theme.of(context).hintColor;
    final demo = ref.watch(demoModeProvider);
    final parsed = parseEvery(_every.text);

    return Scaffold(
      appBar: AppBar(title: const Text('定时任务')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              widget.pane.projectName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SwitchListTile(
            title: const Text('按间隔发送'),
            subtitle: Text(
              on
                  ? '每 ${everyLabel(timer!.everySecs)} 发一次，发完自动回车'
                  : '开启后会定时把下面这条 prompt 发给这个会话',
            ),
            value: on,
            onChanged: _busy || demo
                ? null
                : (want) => want ? _arm() : _disarm(),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _every,
              enabled: !_busy,
              // Re-read on every keystroke so a mistyped unit shows up before
              // it is armed rather than an interval later.
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: '间隔',
                hintText: '30m / 2h / 90s，只写数字按分钟算',
                helperText: parsed == null
                    ? '读不懂这个写法'
                    : '每 ${everyLabel(parsed)} 一次',
                helperStyle: TextStyle(
                  color: parsed == null
                      ? Theme.of(context).colorScheme.error
                      : hint,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _prompt,
              enabled: !_busy,
              maxLines: 4,
              minLines: 2,
              decoration: const InputDecoration(
                labelText: 'prompt',
                hintText: '每次要发给 agent 的那句话',
                alignLabelWithHint: true,
              ),
            ),
          ),
          if (on)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: FilledButton.tonal(
                onPressed: _busy ? null : _arm,
                child: const Text('保存改动'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              demo
                  ? '演示模式：设置不会保存。'
                  : 'agent 正在忙的时候会跳过这一次，等下一个间隔，'
                        '不会把欠下的几次一起补上。'
                        '开启定时会关掉这个会话的 auto 模式——两者都往同一个'
                        '输入框里打字，同时开会互相打断。',
              style: TextStyle(fontSize: 12, color: hint),
            ),
          ),
          if (timer != null && timer.skipped > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '因为忙跳过了 ${timer.skipped} 次',
                style: TextStyle(fontSize: 12, color: hint),
              ),
            ),
        ],
      ),
    );
  }
}
