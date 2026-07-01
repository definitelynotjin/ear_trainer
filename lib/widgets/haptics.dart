import 'package:flutter/services.dart';

/// Centralized haptic feedback helpers.
class Haptics {
  /// Light tap — buttons, note tiles
  static void tap() => HapticFeedback.lightImpact();

  /// Medium — correct answer
  static void correct() => HapticFeedback.mediumImpact();

  /// Heavy — wrong answer
  static void wrong() => HapticFeedback.heavyImpact();

  /// Selection click — choices
  static void select() => HapticFeedback.selectionClick();

  /// Vibrate — achievement unlock
  static void achievement() => HapticFeedback.heavyImpact();
}
