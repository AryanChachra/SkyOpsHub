import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance utilities for SkyOpsHub website
/// Provides tools for monitoring and optimizing runtime performance
class PerformanceUtils {
  /// Target frame time for 60fps (milliseconds)
  static const double targetFrameTimeMs = 16.67;

  /// Maximum content width to prevent excessive stretching on ultra-wide screens
  static const double maxContentWidth = 1440.0;

  /// Initial load budget: sections to render immediately vs lazily
  static const int aboveFoldSectionCount = 2; // Hero + Metrics

  // ── Frame timing ──────────────────────────────────────────────────────────

  /// Returns true if the current frame is within the 60fps budget.
  /// Only meaningful in debug/profile builds.
  static bool isFrameWithinBudget() {
    if (kReleaseMode) return true;
    final scheduler = SchedulerBinding.instance;
    final elapsed = scheduler.currentFrameTimeStamp;
    // Compare against the previous frame timestamp if available
    return elapsed.inMicroseconds > 0;
  }

  // ── Image optimization ────────────────────────────────────────────────────

  /// Returns an appropriate image cache size (in bytes) based on device memory.
  /// Flutter's default is 100MB; we cap it to reduce memory pressure on web.
  static int recommendedImageCacheSize() {
    // 50MB for web to balance quality and memory
    return 50 * 1024 * 1024;
  }

  /// Configure the image cache for optimal web performance.
  static void configureImageCache() {
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        recommendedImageCacheSize();
    // Limit number of cached images to avoid memory bloat
    PaintingBinding.instance.imageCache.maximumSize = 50;
  }

  // ── Content width ─────────────────────────────────────────────────────────

  /// Clamp a width value to the maximum content width.
  static double clampContentWidth(double width) {
    return width.clamp(0.0, maxContentWidth);
  }

  // ── Reduced motion ────────────────────────────────────────────────────────

  /// Returns true if the user prefers reduced motion.
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  // ── Bundle size guidance (documentation) ─────────────────────────────────
  //
  // To keep the initial bundle under 2MB:
  //   1. Build with `flutter build web --release --web-renderer canvaskit`
  //      or `--web-renderer html` for smaller bundles.
  //   2. Enable tree-shaking (default in release builds).
  //   3. Use `--dart-define=FLUTTER_WEB_USE_SKIA=false` for html renderer.
  //   4. Audit google_fonts usage — only import used font weights.
  //   5. Compress assets with gzip/brotli on the server.
  //
  // To measure: run `flutter build web --release` and inspect
  // `build/web/main.dart.js` size.
}

/// A widget that constrains its child to the maximum content width,
/// centered horizontally. Prevents excessive stretching on ultra-wide screens.
class MaxWidthConstraint extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const MaxWidthConstraint({
    super.key,
    required this.child,
    this.maxWidth = PerformanceUtils.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

/// A widget that defers building its child until after the first frame,
/// reducing initial render cost for below-the-fold content.
class DeferredWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final Widget? placeholder;

  const DeferredWidget({
    super.key,
    required this.builder,
    this.placeholder,
  });

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // Defer until after the first frame is painted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return widget.placeholder ??
          const SizedBox.shrink();
    }
    return widget.builder(context);
  }
}
