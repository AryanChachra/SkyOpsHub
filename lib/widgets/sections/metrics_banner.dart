import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../config/redesign_config.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';

/// Metrics Banner Section
/// Displays quantifiable achievements with animated counters
/// Features dark background and responsive layout
class MetricsBanner extends StatefulWidget {
  const MetricsBanner({super.key});

  @override
  State<MetricsBanner> createState() => _MetricsBannerState();
}

class _MetricsBannerState extends State<MetricsBanner> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return VisibilityDetector(
      key: const Key('metrics-banner'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: SkyOpsTheme.darkSectionGradient,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 64,
          vertical: isMobile ? 48 : 80,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Text(
                  'Built for complex airline operations',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: isMobile ? 28 : 40,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 32 : 48),
                isMobile
                    ? Column(
                        children: _buildMetricCards(isMobile),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildMetricCards(isMobile),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMetricCards(bool isMobile) {
    return RedesignConfig.metricsData.asMap().entries.map((entry) {
      final index = entry.key;
      final metric = entry.value;

      return Padding(
        padding: EdgeInsets.only(
          bottom: isMobile ? 32 : 0,
        ),
        child: AnimatedMetricCard(
          metric: metric,
          isVisible: _isVisible,
          delay: Duration(milliseconds: index * 200),
        ),
      );
    }).toList();
  }
}

/// Animated Metric Card
/// Displays a single metric with counter animation and fade-in/slide-up effects
class AnimatedMetricCard extends StatefulWidget {
  final dynamic metric;
  final bool isVisible;
  final Duration delay;

  const AnimatedMetricCard({
    super.key,
    required this.metric,
    required this.isVisible,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedMetricCard> createState() => _AnimatedMetricCardState();
}

class _AnimatedMetricCardState extends State<AnimatedMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _counterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void didUpdateWidget(AnimatedMetricCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: isMobile ? double.infinity : 300,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: '${widget.metric.label}: ${widget.metric.value}',
                child: Icon(
                  widget.metric.icon,
                  size: 48,
                  color: SkyOpsTheme.accentBlue,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _counterAnimation,
                builder: (context, child) {
                  return Semantics(
                    label: '${widget.metric.label}: ${_getAnimatedValue()}',
                    liveRegion: true,
                    child: Text(
                      _getAnimatedValue(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                widget.metric.label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.metric.sublabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: SkyOpsTheme.darkTextSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAnimatedValue() {
    final value = widget.metric.value;
    final progress = _counterAnimation.value;

    // Extract numeric part and suffix
    final numericMatch = RegExp(r'(\$?)(\d+)(\+?)').firstMatch(value);
    if (numericMatch != null) {
      final prefix = numericMatch.group(1) ?? '';
      final number = int.parse(numericMatch.group(2) ?? '0');
      final suffix = numericMatch.group(3) ?? '';

      final animatedNumber = (number * progress).round();
      return '$prefix$animatedNumber$suffix';
    }

    return value;
  }
}
