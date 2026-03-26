import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPaint widget that draws radar grid backgrounds
/// Creates concentric circles and radial lines
class RadarGridPainter extends CustomPainter {
  final Color color;
  final double opacity;

  RadarGridPainter({
    this.color = Colors.white,
    this.opacity = 0.08,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // Draw concentric circles
    for (int i = 1; i <= 4; i++) {
      final radius = maxRadius * (i / 4);
      canvas.drawCircle(center, radius, paint);
    }

    // Draw radial lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final endX = center.dx + maxRadius * math.cos(angle);
      final endY = center.dy + maxRadius * math.sin(angle);
      canvas.drawLine(center, Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(RadarGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}
