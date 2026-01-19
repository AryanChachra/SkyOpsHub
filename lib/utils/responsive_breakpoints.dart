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
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      // Very small screens
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 16);
    } else if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 40);
    }
  }
  
  /// Get responsive margin based on device type
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 12);
    } else if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    }
  }
  
  /// Get safe horizontal padding that prevents overflow
  static EdgeInsets getSafePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final safeHorizontal = (width * 0.05).clamp(8.0, 48.0);
    
    if (isMobile(context)) {
      return EdgeInsets.symmetric(horizontal: safeHorizontal, vertical: 16);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: safeHorizontal, vertical: 24);
    } else {
      return EdgeInsets.symmetric(horizontal: safeHorizontal, vertical: 32);
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
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return 0.8;
    } else if (isMobile(context)) {
      return 0.85;
    } else if (isTablet(context)) {
      return 1.0;
    } else {
      return 1.1;
    }
  }
  
  /// Get responsive spacing between elements
  static double getResponsiveSpacing(BuildContext context, {double base = 16.0}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return base * 0.6;
    } else if (isMobile(context)) {
      return base * 0.75;
    } else if (isTablet(context)) {
      return base;
    } else {
      return base * 1.25;
    }
  }
  
  /// Get safe width that prevents overflow
  static double getSafeWidth(BuildContext context, {double maxWidth = double.infinity}) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 0) return 100;
    
    final padding = getSafePadding(context);
    final availableWidth = screenWidth - padding.horizontal;
    final safeWidth = availableWidth.clamp(100.0, double.infinity);
    
    return maxWidth == double.infinity ? safeWidth : safeWidth.clamp(100, maxWidth);
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
    final screenSize = MediaQuery.of(context).size;
    
    // Safety check for zero or negative dimensions
    if (screenSize.width <= 0 || screenSize.height <= 0) {
      return Container(
        width: 100,
        height: 100,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    
    final maxWidth = ResponsiveBreakpoints.getMaxContentWidth(context);
    final responsivePadding = padding ?? ResponsiveBreakpoints.getSafePadding(context);
    final responsiveMargin = margin ?? ResponsiveBreakpoints.getResponsiveMargin(context);
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: 0,
        minHeight: 0,
      ),
      padding: responsivePadding,
      margin: responsiveMargin,
      child: centerContent && !ResponsiveBreakpoints.isMobile(context)
          ? Center(child: child)
          : child,
    );
  }
}