import 'package:flutter/material.dart';

/// CustomPaint widget that draws runway line patterns
/// Creates parallel diagonal lines with dashed center
class RunwayLinesPainter extends CustomPainter {
  final Color color;
  final double opacity;

  RunwayLinesPainter({
    this.color = Colors.white,
    this.opacity = 0.06,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final dashedPaint = Paint()
      ..color = color.withOpacity(opacity * 1.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Draw parallel lines (runway edges)
    final spacing = size.width * 0.3;
    _drawDiagonalLine(canvas, size, paint, -spacing);
    _drawDiagonalLine(canvas, size, paint, spacing);

    // Draw dashed center line
    _drawDashedCenterLine(canvas, size, dashedPaint);
  }

  void _drawDiagonalLine(Canvas canvas, Size size, Paint paint, double offset) {
    final path = Path();
    path.moveTo(offset, 0);
    path.lineTo(size.width + offset, size.height);
    canvas.drawPath(path, paint);
  }

  void _drawDashedCenterLine(Canvas canvas, Size size, Paint paint) {
    final dashWidth = 20.0;
    final dashSpace = 15.0;
    double startY = 0;

    while (startY < size.height) {
      final startX = (startY / size.height) * size.width;
      final endY = startY + dashWidth;
      final endX = (endY / size.height) * size.width;

      if (endY <= size.height) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      }

      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(RunwayLinesPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}
