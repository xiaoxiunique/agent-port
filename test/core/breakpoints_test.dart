import 'package:agent_port/core/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('windowSizeForWidth', () {
    test('classifies the three bands by width', () {
      expect(windowSizeForWidth(375), WindowSize.compact); // iPhone
      expect(windowSizeForWidth(599), WindowSize.compact);
      expect(windowSizeForWidth(600), WindowSize.medium); // iPad portrait
      expect(windowSizeForWidth(839), WindowSize.medium);
      expect(windowSizeForWidth(840), WindowSize.expanded);
      expect(windowSizeForWidth(1366), WindowSize.expanded); // 13" landscape
    });

    test('a narrow Split View column stays on the phone layout', () {
      // The whole reason this keys on width and not shortestSide: an iPad in a
      // narrow Split View is 320pt wide on a 1366pt screen. A rail and a split
      // detail pane do not fit there.
      expect(windowSizeForWidth(320), WindowSize.compact);
      expect(windowSizeForWidth(320).usesRail, isFalse);
      expect(windowSizeForWidth(320).canSplit, isFalse);
    });

    test('only expanded splits; medium and up take the rail', () {
      expect(WindowSize.compact.usesRail, isFalse);
      expect(WindowSize.medium.usesRail, isTrue);
      expect(WindowSize.expanded.usesRail, isTrue);

      expect(WindowSize.compact.canSplit, isFalse);
      expect(WindowSize.medium.canSplit, isFalse);
      expect(WindowSize.expanded.canSplit, isTrue);
    });
  });

  testWidgets('context.windowSize follows the window as it resizes', (
    tester,
  ) async {
    late WindowSize seen;
    final probe = MaterialApp(
      home: Builder(
        builder: (context) {
          seen = context.windowSize;
          return const SizedBox.shrink();
        },
      ),
    );

    Future<void> pumpAt(double width) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(probe);
      await tester.pump();
    }

    addTearDown(tester.view.reset);

    await pumpAt(375);
    expect(seen, WindowSize.compact);

    // Dragging the Split View divider resizes the window live, so the value
    // has to track it rather than being read once at startup.
    await pumpAt(700);
    expect(seen, WindowSize.medium);

    await pumpAt(1200);
    expect(seen, WindowSize.expanded);

    await pumpAt(320);
    expect(seen, WindowSize.compact);
  });
}
