import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Animation helpers for SkyOpsHub website redesign
/// Provides reusable animation utilities with accessibility support

/// FadeIn animation widget
/// Animates opacity from 0 to 1 over 1200ms with easeOut curve
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool triggerOnScroll;
  final double delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOut,
    this.triggerOnScroll = true,
    this.delay = 0.0,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (!widget.triggerOnScroll) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion preference
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    if (reduceMotion) {
      return widget.child;
    }

    if (widget.triggerOnScroll) {
      return VisibilityDetector(
        key: Key('fade_in_${widget.child.hashCode}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1) {
            _startAnimation();
          }
        },
        child: FadeTransition(
          opacity: _animation,
          child: widget.child,
        ),
      );
    }

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// SlideUp animation widget
/// Animates from Offset(0, 0.3) to Offset.zero over 1000ms with easeOutCubic curve
class SlideUpAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool triggerOnScroll;
  final double delay;
  final Offset beginOffset;

  const SlideUpAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutCubic,
    this.triggerOnScroll = true,
    this.delay = 0.0,
    this.beginOffset = const Offset(0, 0.3),
  });

  @override
  State<SlideUpAnimation> createState() => _SlideUpAnimationState();
}

class _SlideUpAnimationState extends State<SlideUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (!widget.triggerOnScroll) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion preference
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    if (reduceMotion) {
      return widget.child;
    }

    if (widget.triggerOnScroll) {
      return VisibilityDetector(
        key: Key('slide_up_${widget.child.hashCode}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1) {
            _startAnimation();
          }
        },
        child: SlideTransition(
          position: _animation,
          child: widget.child,
        ),
      );
    }

    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

/// Combined FadeIn and SlideUp animation
class FadeSlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool triggerOnScroll;
  final double delay;

  const FadeSlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.triggerOnScroll = true,
    this.delay = 0.0,
  });

  @override
  State<FadeSlideAnimation> createState() => _FadeSlideAnimationState();
}

class _FadeSlideAnimationState extends State<FadeSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (!widget.triggerOnScroll) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion preference
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    if (reduceMotion) {
      return widget.child;
    }

    if (widget.triggerOnScroll) {
      return VisibilityDetector(
        key: Key('fade_slide_${widget.child.hashCode}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1) {
            _startAnimation();
          }
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Hover elevation animation widget
/// Animates scale from 1.0 to 1.02 and elevation from 2 to 8 over 200ms
class HoverElevationCard extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double normalScale;
  final double hoverScale;
  final double normalElevation;
  final double hoverElevation;

  const HoverElevationCard({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.normalScale = 1.0,
    this.hoverScale = 1.02,
    this.normalElevation = 2.0,
    this.hoverElevation = 8.0,
  });

  @override
  State<HoverElevationCard> createState() => _HoverElevationCardState();
}

class _HoverElevationCardState extends State<HoverElevationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: widget.normalScale,
      end: widget.hoverScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.normalElevation,
      end: widget.hoverElevation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion preference
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    if (reduceMotion) {
      return widget.child;
    }

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              elevation: _elevationAnimation.value,
              color: Colors.transparent,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Counter animation widget for metrics
/// Animates from 0 to target value over 800ms
class AnimatedCounter extends StatefulWidget {
  final num value;
  final Duration duration;
  final TextStyle? textStyle;
  final String prefix;
  final String suffix;
  final int decimals;
  final bool triggerOnScroll;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.textStyle,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 0,
    this.triggerOnScroll = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (!widget.triggerOnScroll) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (widget.decimals == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(widget.decimals);
  }

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion preference
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    if (reduceMotion) {
      return Text(
        '${widget.prefix}${_formatNumber(widget.value.toDouble())}${widget.suffix}',
        style: widget.textStyle,
      );
    }

    Widget counterWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_formatNumber(_animation.value)}${widget.suffix}',
          style: widget.textStyle,
        );
      },
    );

    if (widget.triggerOnScroll) {
      return VisibilityDetector(
        key: Key('counter_${widget.value}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.3) {
            _startAnimation();
          }
        },
        child: counterWidget,
      );
    }

    return counterWidget;
  }
}

/// Utility class for animation helpers
class AnimationHelpers {
  /// Standard fade-in duration
  static const Duration fadeInDuration = Duration(milliseconds: 1200);
  
  /// Standard slide-up duration
  static const Duration slideUpDuration = Duration(milliseconds: 1000);
  
  /// Standard hover duration
  static const Duration hoverDuration = Duration(milliseconds: 200);
  
  /// Standard counter duration
  static const Duration counterDuration = Duration(milliseconds: 800);
  
  /// Check if reduced motion is preferred
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
  
  /// Create a staggered delay for multiple animations
  static double staggerDelay(int index, {double baseDelay = 0.1}) {
    return index * baseDelay;
  }
}
