import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/usage_daily.dart';
import '../../services/api_provider.dart';
import 'widgets/settings_rows.dart';

/// Claude Code + Codex token spend, total and per-day.
///
/// Split out of settings_view.dart, which held every settings screen in one
/// 1900-line file.

class UsagePage extends ConsumerWidget {
  const UsagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(usageDailyProvider);
    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(title: const Text('用量统计')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _UsageHint('读取用量失败：$e'),
        data: (u) {
          if (!u.ok) {
            return const _UsageHint('服务端未能获取用量数据。\n请确认主机已安装 ccusage（bunx ccusage）。');
          }
          final today = u.days.isNotEmpty ? u.days.first : null;
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(usageDailyProvider),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                const _UsageSection('总共'),
                _TotalCard(u: u),
                const SizedBox(height: 22),
                _UsageSection(today != null ? '当日 · ${today.date}' : '当日'),
                if (today != null)
                  _DayCard(day: today, emphasize: true)
                else
                  const _UsageHint('今日暂无用量'),
                const SizedBox(height: 22),
                const _UsageSection('每天'),
                ...u.days.map((d) => _DayCard(day: d)),
                if (u.days.isEmpty) const _UsageHint('暂无历史用量'),
                const SizedBox(height: 16),
                Text(
                  '成本为 ccusage 按 API 单价估算，订阅 / Max 套餐下仅供参考。',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UsageSection extends StatelessWidget {
  const _UsageSection(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
          ),
        ),
      );
}

class _UsageHint extends StatelessWidget {
  const _UsageHint(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
      );
}

/// Card backing for usage rows — white (or dark) rounded surface.
class _UsageCard extends StatelessWidget {
  const _UsageCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

/// All-time total: grand total cost + Claude / Codex split.
class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.u});
  final UsageDaily u;
  @override
  Widget build(BuildContext context) {
    return _UsageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _money(u.totalCost),
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Text('总消费',
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).hintColor)),
            ],
          ),
          const SizedBox(height: 14),
          _AgentLine(
            label: 'Claude',
            color: const Color(0xFFD97757),
            cost: u.claude.cost,
            tokens: u.claude.totalTokens,
          ),
          const SizedBox(height: 8),
          _AgentLine(
            label: 'Codex',
            color: const Color(0xFF10A37F),
            cost: u.codex.cost,
            tokens: u.codex.totalTokens,
          ),
        ],
      ),
    );
  }
}

/// One day's spend: date header + Claude / Codex split. `emphasize` enlarges
/// the total for the "today" card.
class _DayCard extends StatelessWidget {
  const _DayCard({required this.day, this.emphasize = false});
  final DayUsage day;
  final bool emphasize;
  @override
  Widget build(BuildContext context) {
    return _UsageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day.date,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                _money(day.totalCost),
                style: TextStyle(
                  fontSize: emphasize ? 22 : 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _AgentLine(
            label: 'Claude',
            color: const Color(0xFFD97757),
            cost: day.claudeCost,
            tokens: day.claudeTokens,
            compact: true,
          ),
          const SizedBox(height: 6),
          _AgentLine(
            label: 'Codex',
            color: const Color(0xFF10A37F),
            cost: day.codexCost,
            tokens: day.codexTokens,
            compact: true,
          ),
        ],
      ),
    );
  }
}

/// A single agent's line: colored dot · name · tokens (right: cost).
class _AgentLine extends StatelessWidget {
  const _AgentLine({
    required this.label,
    required this.color,
    required this.cost,
    required this.tokens,
    this.compact = false,
  });
  final String label;
  final Color color;
  final double cost;
  final int tokens;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final hint = Theme.of(context).hintColor;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 54,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Text('${_fmtTok(tokens)} tok',
            style: TextStyle(fontSize: 12, color: hint)),
        const Spacer(),
        Text(_money(cost),
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: cost > 0 ? null : hint,
            )),
      ],
    );
  }
}

// ===========================================================================
// Sub-page: Project history
// ===========================================================================

/// Recent-projects picker: pick a past project and launch Claude/Codex on it.
/// Reached from the home list's "添加项目" entry. Public so the monitor feature
/// can reuse it.

String _fmtTok(int n) {
  if (n >= 1000000000) return '${(n / 1e9).toStringAsFixed(1)}B';
  if (n >= 1000000) return '${(n / 1e6).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1e3).toStringAsFixed(1)}K';
  return '$n';
}

String _money(double v) => '\$${v.toStringAsFixed(2)}';
