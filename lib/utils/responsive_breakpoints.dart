import 'package:flutter/material.dart';

/// Responsive breakpoint system for SkyOpsHub website
/// Defines mobile, tablet, and desktop breakpoints with utility methods
class ResponsiveBreakpoints {
  // Breakpoint definitions
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1440;
  
  /// Check if current screen width is mobile (< 768px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }
  
  /// Check if current screen width is tablet (768px - 1024px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }
  
  /// Check if current screen width is desktop (>= 1024px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
  
  /// Get the current device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return DeviceType.mobile;
    if (width < tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  /// Get responsive padding based on device type
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 40);
    }
  }
  
  /// Get responsive margin based on device type
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    }
  }
  
  /// Get maximum content width for centering
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return MediaQuery.of(context).size.width;
    } else if (isTablet(context)) {
      return 800;
    } else {
      return 1200;
    }
  }
  
  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) {
      return 0.9;
    } else if (isTablet(context)) {
      return 1.0;
    } else {
      return 1.1;
    }
  }
  
  /// Get responsive grid column count
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }
}

/// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Responsive widget that builds different layouts based on screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return mobile;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return tablet ?? desktop;
    } else {
      return desktop;
    }
  }
}

/// Responsive container that adapts its constraints based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool centerContent;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.centerContent = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveBreakpoints.getMaxContentWidth(context);
    final responsivePadding = padding ?? ResponsiveBreakpoints.getResponsivePadding(context);
    final responsiveMargin = margin ?? ResponsiveBreakpoints.getResponsiveMargin(context);
    
    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: responsivePadding,
      margin: responsiveMargin,
      child: child,
    );
    
    if (centerContent && !ResponsiveBreakpoints.isMobile(context)) {
      content = Center(child: content);
    }
    
    return content;
  }
}