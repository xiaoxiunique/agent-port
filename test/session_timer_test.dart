import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_port/data/models/session_timer.dart';

void main() {
  group('an interval reads the way it is written', () {
    test('units', () {
      expect(parseEvery('30m'), 1800);
      expect(parseEvery('2h'), 7200);
      expect(parseEvery('90s'), 90);
      expect(parseEvery(' 15 M '), 900);
    });

    test('a bare number is minutes', () {
      // Deliberately not "30" — that would equal the old fallback, so it would
      // pass whether or not bare numbers were understood at all.
      expect(parseEvery('5'), 300);
      expect(parseEvery('45'), 2700);
    });

    test('the floor and ceiling are the daemon\'s', () {
      expect(parseEvery('5s'), kTimerMinEverySecs);
      expect(parseEvery('0m'), kTimerMinEverySecs);
      expect(parseEvery('99h'), kTimerMaxEverySecs);
    });

    test('unreadable text is refused, not guessed at', () {
      expect(parseEvery(''), isNull);
      expect(parseEvery('soon'), isNull);
      expect(parseEvery('10 fortnights'), isNull);
      // What you get by tabbing into a pre-filled field and typing.
      expect(parseEvery('30m2m'), isNull);
      // Without the one-run check this reads as 230 minutes.
      expect(parseEvery('2m30'), isNull);
    });

    test('a label round-trips back through the parser', () {
      for (final secs in [90, 900, 1800, 7200, 86400]) {
        expect(parseEvery(everyLabel(secs)), secs, reason: 'for $secs');
      }
    });
  });

  test('timers are read out of a real snapshot payload', () {
    // Captured verbatim from the amux serve daemon.
    final json =
        jsonDecode('''
    {"ok":true,"panes":[
      {"id":"%1","session":"cx_ttimer_f365d18d","status":"idle",
       "timer":{"session":"cx_ttimer_f365d18d","prompt":"look at CI",
                "everySecs":900,"lastRunAt":"2026-09-17T08:42:44.979Z",
                "skipped":0,"enabled":true}},
      {"id":"%2","session":"cc_other_11111111","status":"idle"}]}
    ''')
            as Map<String, dynamic>;

    final timers = timersFromSnapshotJson(json);

    // The pane with no schedule contributes nothing rather than a disabled
    // entry — absence is how the server says "not armed".
    expect(timers.keys, ['cx_ttimer_f365d18d']);
    final t = timers['cx_ttimer_f365d18d']!;
    expect(t.prompt, 'look at CI');
    expect(t.everySecs, 900);
    expect(t.enabled, isTrue);
    expect(everyLabel(t.everySecs), '15m');
  });
}
