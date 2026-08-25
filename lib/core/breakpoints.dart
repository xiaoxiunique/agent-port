import 'package:flutter/widgets.dart';

/// Window size classes, keyed on the **window's width** — not the device's.
///
/// The distinction matters on iPad: `UIRequiresFullScreen` is not set, so the
/// app can be dragged into Split View and run at 320pt wide on a 13" screen.
/// Deciding on `MediaQuery.size.shortestSide` (or on "is this an iPad") would
/// hand that sliver a tablet layout. Width is what the layout actually has.
///
/// Boundaries follow Material 3's window size classes, which line up with the
/// widths iPadOS actually produces in Split View.
enum WindowSize {
  /// Phones, and an iPad in a narrow Split View column. Bottom tab bar.
  compact,

  /// iPad portrait, or half of a landscape Split View. Rail, still one column.
  medium,

  /// iPad landscape full screen. Rail plus a list/detail split.
  expanded;

  /// Wide enough to show a list and its detail side by side.
  bool get canSplit => this == WindowSize.expanded;

  /// Wide enough that a bottom tab bar reads as stranded.
  bool get usesRail => this != WindowSize.compact;
}

/// Width below which we stay on the phone layout.
const double kMediumWidth = 600;

/// Width at or above which a list and its detail fit side by side.
const double kExpandedWidth = 840;

WindowSize windowSizeForWidth(double width) {
  if (width >= kExpandedWidth) return WindowSize.expanded;
  if (width >= kMediumWidth) return WindowSize.medium;
  return WindowSize.compact;
}

extension WindowSizeContext on BuildContext {
  /// The current window size class.
  ///
  /// Uses `MediaQuery.sizeOf`, so a widget reading this rebuilds when the
  /// window resizes — which on iPad happens live as the Split View divider is
  /// dragged, not just on rotation.
  WindowSize get windowSize => windowSizeForWidth(MediaQuery.sizeOf(this).width);
}
