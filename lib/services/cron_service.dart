import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cron.dart';
import 'api_provider.dart';
import 'demo_data.dart';

/// CronBox schedules on the host. Refetched when the active profile changes.
final cronSchedulesProvider =
    FutureProvider.autoDispose<List<CronSchedule>>((ref) async {
  if (ref.watch(demoModeProvider)) return const [];
  return ref.watch(apiProvider).cronSchedules();
});

/// Recent job runs, newest first.
///
/// Capped at 50: the host keeps thousands of rows, and a phone list doesn't
/// need more than the recent window.
final cronJobsProvider = FutureProvider.autoDispose<List<CronJob>>((ref) async {
  if (ref.watch(demoModeProvider)) return const [];
  return ref.watch(apiProvider).cronJobs(limit: 50);
});

/// Runs for one schedule, for its detail view.
final cronJobsForScheduleProvider = FutureProvider.autoDispose
    .family<List<CronJob>, String>((ref, scheduleId) async {
  if (ref.watch(demoModeProvider)) return const [];
  return ref.watch(apiProvider).cronJobs(limit: 30, scheduleId: scheduleId);
});

/// One job's captured output, fetched on demand — logs are excluded from the
/// list responses because they run to tens of MB across all history.
final cronLogProvider =
    FutureProvider.autoDispose.family<String, String>((ref, jobId) async {
  if (ref.watch(demoModeProvider)) return '';
  final r = await ref.watch(apiProvider).cronLog(jobId);
  return r.logs;
});

/// Runs `enable` / `disable` / `cancel` / `trigger`, then refreshes the lists
/// so the UI reflects the new state.
///
/// Takes a [WidgetRef] because it's invoked from widget callbacks.
Future<void> runCronAction(
  WidgetRef ref, {
  required String action,
  required String id,
}) async {
  await ref.read(apiProvider).cronAction(action: action, id: id);
  ref.invalidate(cronSchedulesProvider);
  ref.invalidate(cronJobsProvider);
}
