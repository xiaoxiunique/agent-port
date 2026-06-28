// Per-session push-notification config from `/api/pane/notify-config`.
// Hand-written (no codegen). `events` is a subset of {"waiting", "done"}.

/// A session's notification preferences (keyed server-side by the pane's path).
class NotifyConfig {
  const NotifyConfig({required this.enabled, required this.events});

  final bool enabled;
  final List<String> events;

  bool get waiting => events.contains('waiting');
  bool get done => events.contains('done');

  const NotifyConfig.off()
      : enabled = false,
        events = const ['waiting', 'done'];

  NotifyConfig copyWith({bool? enabled, List<String>? events}) => NotifyConfig(
        enabled: enabled ?? this.enabled,
        events: events ?? this.events,
      );

  factory NotifyConfig.fromJson(Map<String, dynamic> json) => NotifyConfig(
        enabled: json['enabled'] as bool? ?? false,
        events: (json['events'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
      );
}
