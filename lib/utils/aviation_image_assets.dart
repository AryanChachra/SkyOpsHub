import 'package:flutter/material.dart';

/// Aviation image asset paths and utilities
/// Provides centralized management of aviation imagery with fallback support
class AviationImageAssets {
  // Hero section images
  static const String heroAircraft = 'assets/images/hero_aircraft.webp';
  static const String heroDashboard = 'assets/images/hero_dashboard.webp';
  static const String heroControlCenter =
      'assets/images/hero_control_center.webp';

  // Case study images
  static const String caseStudyDelayReduction =
      'assets/images/case_study_delay.webp';
  static const String caseStudyTurnaround =
      'assets/images/case_study_turnaround.webp';
  static const String caseStudyRecovery =
      'assets/images/case_study_recovery.webp';
  static const String caseStudyCrewOptimization =
      'assets/images/case_study_crew.webp';

  // Flight operations imagery
  static const String flightOperations = 'assets/images/flight_operations.webp';
  static const String aircraftOnRunway = 'assets/images/aircraft_runway.webp';
  static const String controlRoom = 'assets/images/control_room.webp';

  /// Get case study image by airline type or scenario
  static String getCaseStudyImage(String airlineType) {
    final type = airlineType.toLowerCase();
    if (type.contains('regional')) {
      return caseStudyDelayReduction;
    } else if (type.contains('international')) {
      return caseStudyTurnaround;
    } else if (type.contains('low-cost') || type.contains('carrier')) {
      return caseStudyRecovery;
    }
    return caseStudyCrewOptimization;
  }

  /// Build image widget with lazy loading and fallback.
  /// Uses [frameBuilder] for smooth fade-in on load.
  /// [semanticLabel] provides alt text for screen readers (accessibility).
  static Widget buildImage({
    required String assetPath,
    required Widget fallback,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    bool lazyLoad = false,
    String? semanticLabel,
  }) {
    Widget image = Semantics(
      label: semanticLabel,
      image: true,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        // Cache at display size to reduce memory usage
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        errorBuilder: (context, error, stackTrace) => fallback,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius, child: image);
    }

    if (lazyLoad) {
      return _LazyImage(
        width: width,
        height: height,
        fallback: fallback,
        child: image,
      );
    }

    return image;
  }

  /// Build fallback placeholder for failed image loads
  static Widget buildFallbackPlaceholder({
    required IconData icon,
    required Color color,
    double? width,
    double? height,
    String? label,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color.withOpacity(0.3)),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build hero section visual with dashboard preview
  static Widget buildHeroVisual({
    required BuildContext context,
    required bool isMobile,
  }) {
    return buildImage(
      assetPath: heroDashboard,
      fit: BoxFit.contain,
      height: isMobile ? 200 : 300,
      borderRadius: BorderRadius.circular(20),
      semanticLabel:
          'SkyOpsHub flight operations dashboard preview showing real-time flight data',
      fallback: buildFallbackPlaceholder(
        icon: Icons.dashboard_outlined,
        color: Colors.white,
        height: isMobile ? 200 : 300,
        label: 'Dashboard Preview (Coming Soon)',
      ),
    );
  }

  /// Build case study image with fallback (lazy loaded)
  static Widget buildCaseStudyImage({
    required String airlineType,
    required double height,
    BorderRadius? borderRadius,
  }) {
    final imagePath = getCaseStudyImage(airlineType);
    return buildImage(
      assetPath: imagePath,
      height: height,
      fit: BoxFit.cover,
      borderRadius: borderRadius,
      lazyLoad: true,
      semanticLabel: 'Aviation operations imagery for $airlineType case study',
      fallback: buildFallbackPlaceholder(
        icon: Icons.flight,
        color: const Color(0xFF0B3D91),
        height: height,
        label: 'Aviation Operations',
      ),
    );
  }
}

/// Lazy-loading wrapper that defers rendering until the widget is near the viewport.
class _LazyImage extends StatefulWidget {
  final Widget child;
  final Widget fallback;
  final double? width;
  final double? height;

  const _LazyImage({
    required this.child,
    required this.fallback,
    this.width,
    this.height,
  });

  @override
  State<_LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<_LazyImage> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => false,
      child: Builder(
        builder: (context) {
          if (!_visible) {
            // Use a post-frame callback to check visibility
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              final renderObject = context.findRenderObject();
              if (renderObject is RenderBox && renderObject.hasSize) {
                final position = renderObject.localToGlobal(Offset.zero);
                final screenHeight = MediaQuery.of(context).size.height;
                // Load when within 1.5x screen height of viewport
                if (position.dy < screenHeight * 1.5) {
                  setState(() => _visible = true);
                }
              }
            });
            return SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.fallback,
            );
          }
          return widget.child;
        },
      ),
    );
  }
}
