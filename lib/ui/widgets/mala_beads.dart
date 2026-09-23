import 'dart:math';
import 'package:flutter/material.dart';

class MalaBeadsPainter extends CustomPainter {
  final int currentCount;
  final int totalBeads;
  final Color activeColor;
  final Color inactiveColor;

  MalaBeadsPainter({
    required this.currentCount,
    required this.totalBeads,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalBeads <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - 16) / 2;

    // Determine bead radius based on total bead density
    double beadRadius = 2.4;
    if (totalBeads <= 27) {
      beadRadius = 5.0;
    } else if (totalBeads <= 54) {
      beadRadius = 3.8;
    } else if (totalBeads <= 108) {
      beadRadius = 2.4;
    } else {
      beadRadius = 1.6;
    }

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    final guruBeadPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw Guru bead at top (12 o'clock)
    final guruOffset = Offset(center.dx, center.dy - radius - beadRadius - 2);
    canvas.drawCircle(guruOffset, beadRadius * 1.3, guruBeadPaint);

    for (int i = 0; i < totalBeads; i++) {
      // Angle starting from top (after guru bead) clockwise
      final angle = -pi / 2 + (2 * pi * i / totalBeads);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final beadOffset = Offset(x, y);

      final bool isActive = i < currentCount;
      final bool isCurrentBead = i == (currentCount - 1);

      if (isCurrentBead) {
        // Subtle highlight for current bead
        final highlightPaint = Paint()
          ..color = activeColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(beadOffset, beadRadius * 2.0, highlightPaint);
        canvas.drawCircle(beadOffset, beadRadius * 1.2, activePaint);
      } else if (isActive) {
        canvas.drawCircle(beadOffset, beadRadius, activePaint);
      } else {
        canvas.drawCircle(beadOffset, beadRadius * 0.8, inactivePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MalaBeadsPainter oldDelegate) {
    return oldDelegate.currentCount != currentCount ||
        oldDelegate.totalBeads != totalBeads ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
