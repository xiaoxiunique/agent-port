// Pending-message queue models (Claude Code only). Hand-written (no codegen)
// to mirror the Rust `/api/pending*` endpoints.

/// One queued message awaiting an idle Claude pane.
class PendingMessage {
  const PendingMessage({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String createdAt;

  factory PendingMessage.fromJson(Map<String, dynamic> json) => PendingMessage(
        id: json['id'] as String? ?? '',
        text: json['text'] as String? ?? '',
        createdAt: json['createdAt'] as String? ?? '',
      );
}

/// Response of `GET /api/pending` and the mutation endpoints.
class PendingList {
  const PendingList({
    required this.ok,
    required this.paneId,
    required this.messages,
  });

  final bool ok;
  final String paneId;
  final List<PendingMessage> messages;

  int get count => messages.length;

  const PendingList.empty(this.paneId)
      : ok = true,
        messages = const [];

  factory PendingList.fromJson(Map<String, dynamic> json) => PendingList(
        ok: json['ok'] as bool? ?? false,
        paneId: json['paneId'] as String? ?? '',
        messages: (json['messages'] as List<dynamic>? ?? const [])
            .map((e) => PendingMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// Result of `POST /api/send`: either delivered immediately, or held in the
/// pending queue (`queued == true`) because the Claude pane was busy.
class SendResult {
  const SendResult({
    required this.ok,
    required this.queued,
    required this.pendingCount,
    this.tail,
  });

  final bool ok;
  final bool queued;
  final int pendingCount;
  final String? tail;

  factory SendResult.fromJson(Map<String, dynamic> json) => SendResult(
        ok: json['ok'] as bool? ?? false,
        queued: json['queued'] as bool? ?? false,
        pendingCount: json['pendingCount'] as int? ?? 0,
        tail: json['tail'] as String?,
      );
}
