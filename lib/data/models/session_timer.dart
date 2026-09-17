/// A standing prompt sent to one session on an interval.
///
/// Not to be confused with [CronSchedule] in `cron.dart`, which belongs to
/// CronBox — a separate scheduler that runs shell scripts. This is amux's own
/// per-session timer: it types a fixed prompt into an agent and presses enter.
///
/// Hand-written rather than freezed on purpose: `build_runner` cannot run in
/// this project (a dependency declares a native build hook, which
/// `dart compile aot-snapshot` refuses outright), so anything that needs code
/// generation cannot be added. The class is small enough that the generated
/// version would not have earned its keep anyway.
class SessionTimer {
  const SessionTimer({
    required this.session,
    required this.prompt,
    required this.everySecs,
    this.lastRunAt = '',
    this.skipped = 0,
    this.enabled = false,
  });

  final String session;
  final String prompt;
  final int everySecs;

  /// When the prompt was last actually sent — not when it was next due. After a
  /// skip the next run counts from here, so a busy agent costs one run rather
  /// than banking up a burst.
  final String lastRunAt;

  /// Runs skipped because the agent was working. Shown, not acted on.
  final int skipped;
  final bool enabled;

  static SessionTimer? fromJson(Map<String, dynamic> json) {
    final session = json['session'];
    final every = json['everySecs'];
    if (session is! String || every is! int) return null;
    return SessionTimer(
      session: session,
      prompt: json['prompt'] as String? ?? '',
      everySecs: every,
      lastRunAt: json['lastRunAt'] as String? ?? '',
      skipped: json['skipped'] as int? ?? 0,
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}

/// The interval floor the daemon enforces. Applied here too so the form cannot
/// show a promise the server will not keep.
const int kTimerMinEverySecs = 60;
const int kTimerMaxEverySecs = 24 * 60 * 60;

/// Read `30m` / `2h` / `90s` / a bare number of minutes, or return null.
///
/// Deliberately the same rules as the TUI's `timer_parse_every`, including the
/// refusal: there is no fallback interval, because arming on a silent default
/// would start typing at a session on a schedule nobody chose.
int? parseEvery(String raw) {
  final text = raw.trim().toLowerCase();
  if (text.isEmpty) return null;

  final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
  final unit = text.replaceAll(RegExp(r'[0-9]'), '').trim();
  final n = int.tryParse(digits);
  if (n == null) return null;

  // Digits must be one leading run. Without this `2m30` reads as 230 minutes,
  // because stripping the letters throws away where they sat.
  if (RegExp(r'^[0-9]*').firstMatch(text)!.group(0)!.length != digits.length) {
    return null;
  }

  final int secs;
  switch (unit) {
    case 's':
    case 'sec':
    case 'secs':
      secs = n;
    case 'h':
    case 'hr':
    case 'hour':
    case 'hours':
      secs = n * 3600;
    // A bare number reads as minutes: nobody schedules a standing instruction
    // in seconds, and "5" meaning five seconds would surprise.
    case '':
    case 'm':
    case 'min':
    case 'mins':
      secs = n * 60;
    default:
      return null;
  }
  return secs.clamp(kTimerMinEverySecs, kTimerMaxEverySecs);
}

/// How an interval is written back — the inverse of [parseEvery] for the values
/// it can express exactly.
String everyLabel(int secs) {
  if (secs % 3600 == 0) return '${secs ~/ 3600}h';
  if (secs % 60 == 0) return '${secs ~/ 60}m';
  return '${secs}s';
}

/// Pull the armed timers out of a raw `/api/snapshot` (or websocket) payload,
/// keyed by session.
///
/// Read from the raw map rather than from [Pane] because [Pane] is freezed and
/// cannot gain a field while code generation is blocked. The payload is already
/// decoded at both call sites, so this costs a walk, not a request.
Map<String, SessionTimer> timersFromSnapshotJson(Map<String, dynamic> json) {
  final panes = json['panes'];
  if (panes is! List) return const {};
  final out = <String, SessionTimer>{};
  for (final pane in panes) {
    if (pane is! Map<String, dynamic>) continue;
    final raw = pane['timer'];
    if (raw is! Map<String, dynamic>) continue;
    final timer = SessionTimer.fromJson(raw);
    if (timer != null) out[timer.session] = timer;
  }
  return out;
}
