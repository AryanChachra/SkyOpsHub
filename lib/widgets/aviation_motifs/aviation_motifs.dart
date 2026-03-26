import 'package:flutter/material.dart';
import 'flight_path_painter.dart';
import 'radar_grid_painter.dart';
import 'runway_lines_painter.dart';

/// Utility class for creating aviation-themed visual motifs
/// Provides factory methods for flight paths, radar grids, and runway lines
class AviationMotifs {
  /// Creates a CustomPaint widget with flight path overlays
  /// 
  /// [color] - The color of the flight paths (default: white)
  /// [opacity] - The opacity of the flight paths (default: 0.1)
  static Widget flightPaths({
    Color color = Colors.white,
    double opacity = 0.1,
  }) {
    return CustomPaint(
      painter: FlightPathPainter(
        color: color,
        opacity: opacity,
      ),
      child: Container(),
    );
  }

  /// Creates a CustomPaint widget with radar grid background
  /// 
  /// [color] - The color of the radar grid (default: white)
  /// [opacity] - The opacity of the radar grid (default: 0.08)
  static Widget radarGrid({
    Color color = Colors.white,
    double opacity = 0.08,
  }) {
    return CustomPaint(
      painter: RadarGridPainter(
        color: color,
        opacity: opacity,
      ),
      child: Container(),
    );
  }

  /// Creates a CustomPaint widget with runway line patterns
  /// 
  /// [color] - The color of the runway lines (default: white)
  /// [opacity] - The opacity of the runway lines (default: 0.06)
  static Widget runwayLines({
    Color color = Colors.white,
    double opacity = 0.06,
  }) {
    return CustomPaint(
      painter: RunwayLinesPainter(
        color: color,
        opacity: opacity,
      ),
      child: Container(),
    );
  }

  /// Creates a stacked combination of multiple aviation motifs
  /// 
  /// [motifs] - List of motif widgets to stack
  /// [child] - Optional child widget to display on top of motifs
  static Widget layered({
    required List<Widget> motifs,
    Widget? child,
  }) {
    return Stack(
      children: [
        ...motifs.map((motif) => Positioned.fill(child: motif)),
        if (child != null) child,
      ],
    );
  }
}
