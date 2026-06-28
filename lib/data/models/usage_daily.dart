// Per-day usage breakdown from `GET /api/usage/daily` (server-side ccusage,
// claude + codex merged by date, newest-first). Hand-written (no codegen).

import 'token_usage.dart';

/// One calendar day's Claude + Codex spend.
class DayUsage {
  const DayUsage({
    required this.date,
    this.claudeTokens = 0,
    this.claudeCost = 0,
    this.codexTokens = 0,
    this.codexCost = 0,
  });

  final String date;
  final int claudeTokens;
  final double claudeCost;
  final int codexTokens;
  final double codexCost;

  int get totalTokens => claudeTokens + codexTokens;
  double get totalCost => claudeCost + codexCost;

  factory DayUsage.fromJson(Map<String, dynamic> json) => DayUsage(
        date: json['date'] as String? ?? '',
        claudeTokens: (json['claudeTokens'] as num?)?.toInt() ?? 0,
        claudeCost: (json['claudeCost'] as num?)?.toDouble() ?? 0,
        codexTokens: (json['codexTokens'] as num?)?.toInt() ?? 0,
        codexCost: (json['codexCost'] as num?)?.toDouble() ?? 0,
      );
}

/// Response of `GET /api/usage/daily`: all-time totals plus a newest-first list
/// of per-day rows.
class UsageDaily {
  const UsageDaily({
    required this.ok,
    required this.claude,
    required this.codex,
    required this.days,
  });

  final bool ok;
  final AgentUsage claude;
  final AgentUsage codex;
  final List<DayUsage> days;

  /// All-time grand total cost across both agents.
  double get totalCost => claude.cost + codex.cost;

  factory UsageDaily.fromJson(Map<String, dynamic> json) => UsageDaily(
        ok: json['ok'] as bool? ?? false,
        claude: AgentUsage.fromJson(json['claude'] as Map<String, dynamic>?),
        codex: AgentUsage.fromJson(json['codex'] as Map<String, dynamic>?),
        days: (json['days'] as List<dynamic>? ?? const [])
            .map((e) => DayUsage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
