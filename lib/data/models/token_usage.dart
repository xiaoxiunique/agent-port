/// Total token usage for an agent (Claude Code or Codex), from `GET /api/usage`
/// (computed server-side via ccusage). Hand-written (no codegen).
class AgentUsage {
  const AgentUsage({
    this.totalTokens = 0,
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.cost = 0,
  });

  final int totalTokens;
  final int inputTokens;
  final int outputTokens;
  final double cost;

  factory AgentUsage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AgentUsage();
    return AgentUsage(
      totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
      inputTokens: (json['inputTokens'] as num?)?.toInt() ?? 0,
      outputTokens: (json['outputTokens'] as num?)?.toInt() ?? 0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TokenUsage {
  const TokenUsage({required this.ok, required this.claude, required this.codex});

  final bool ok;
  final AgentUsage claude;
  final AgentUsage codex;

  factory TokenUsage.fromJson(Map<String, dynamic> json) => TokenUsage(
        ok: json['ok'] as bool? ?? false,
        claude: AgentUsage.fromJson(json['claude'] as Map<String, dynamic>?),
        codex: AgentUsage.fromJson(json['codex'] as Map<String, dynamic>?),
      );
}
