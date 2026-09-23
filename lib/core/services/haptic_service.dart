import 'package:flutter/services.dart';

enum HapticLevel { off, light, medium }

class HapticService {
  static void triggerTap(HapticLevel level) {
    switch (level) {
      case HapticLevel.light:
        HapticFeedback.selectionClick();
        break;
      case HapticLevel.medium:
        HapticFeedback.lightImpact();
        break;
      case HapticLevel.off:
        break;
    }
  }

  static void triggerCompletion(HapticLevel level) {
    if (level == HapticLevel.off) return;
    HapticFeedback.mediumImpact();
  }
}
