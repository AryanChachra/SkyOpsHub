import 'package:flutter/material.dart';

/// CustomPaint widget that draws flight path overlays
/// Creates curved lines suggesting aircraft trajectories
class FlightPathPainter extends CustomPainter {
  final Color color;
  final double opacity;

  FlightPathPainter({
    this.color = Colors.white,
    this.opacity = 0.1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw multiple curved flight paths across the canvas
    _drawFlightPath(canvas, size, paint, 0.2, 0.3, 0.8, 0.4);
    _drawFlightPath(canvas, size, paint, 0.1, 0.6, 0.7, 0.2);
    _drawFlightPath(canvas, size, paint, 0.3, 0.8, 0.9, 0.5);
  }

  void _drawFlightPath(
    Canvas canvas,
    Size size,
    Paint paint,
    double startX,
    double startY,
    double endX,
    double endY,
  ) {
    final path = Path();
    final start = Offset(size.width * startX, size.height * startY);
    final end = Offset(size.width * endX, size.height * endY);
    
    // Create a curved path using quadratic bezier
    final controlPoint = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2 - size.height * 0.1,
    );
    
    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      end.dx,
      end.dy,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(FlightPathPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}
