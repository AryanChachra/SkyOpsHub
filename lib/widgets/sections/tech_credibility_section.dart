import 'package:flutter/material.dart';
import '../../theme/skyops_theme.dart';
import '../../config/redesign_config.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/animation_helpers.dart';

/// Technology Credibility Section
/// Displays performance metrics and certifications to establish technical credibility
/// Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 9.7
class TechCredibilitySection extends StatelessWidget {
  const TechCredibilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ResponsiveBreakpoints.tablet;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: SkyOpsTheme.darkSectionGradient,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24.0 : 64.0,
          vertical: isMobile ? 48.0 : 80.0,
        ),
        child: FadeSlideAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section headline
              Text(
                'Platform capabilities for airline operations',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: SkyOpsTheme.darkTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Built to support mission-critical airline operations and real-time scheduling decisions',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: SkyOpsTheme.darkTextSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Performance metrics
              _buildPerformanceMetrics(context, isMobile),

              // const SizedBox(height: 64),

              // Certifications section
              // _buildCertifications(context, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, bool isMobile) {
    return isMobile
        ? Column(
            children: RedesignConfig.performanceMetrics
                .map((metric) => Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: _PerformanceMetricCard(metric: metric),
                    ))
                .toList(),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: RedesignConfig.performanceMetrics
                .map((metric) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _PerformanceMetricCard(metric: metric),
                      ),
                    ))
                .toList(),
          );
  }

  // Widget _buildCertifications(BuildContext context, bool isMobile) {
  //   return Column(
  //     children: [
  //       Text(
  //         'Security & Compliance',
  //         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  //               color: SkyOpsTheme.darkTextPrimary,
  //               fontWeight: FontWeight.bold,
  //             ),
  //         textAlign: TextAlign.center,
  //       ),
  //       const SizedBox(height: 32),
  //       Wrap(
  //         alignment: WrapAlignment.center,
  //         spacing: isMobile ? 16.0 : 24.0,
  //         runSpacing: 16.0,
  //         children: RedesignConfig.certifications
  //             .map((cert) => _CertificationBadge(certification: cert))
  //             .toList(),
  //       ),
  //     ],
  //   );
  // }
}

/// Performance Metric Card
/// Displays individual performance metric with icon, value, label, and description
class _PerformanceMetricCard extends StatelessWidget {
  final dynamic metric;

  const _PerformanceMetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${metric.label}: ${metric.value}. ${metric.description}',
      child: HoverElevationCard(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: SkyOpsTheme.darkSurfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SkyOpsTheme.accentBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Icon
              Icon(
                metric.icon,
                size: 48,
                color: SkyOpsTheme.accentBlue,
                semanticLabel: metric.label,
              ),
              const SizedBox(height: 16),

              // Label
              Text(
                metric.label,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: SkyOpsTheme.accentBlue,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 8),

              // Label
              // Text(
              //   metric.label,
              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //         color: SkyOpsTheme.accentBlue,
              //         fontWeight: FontWeight.w600,
              //       ),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 12),

              // Description
              Text(
                metric.description,
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
}

/// Certification Badge
/// Displays individual certification in a styled badge
class _CertificationBadge extends StatelessWidget {
  final String certification;

  const _CertificationBadge({required this.certification});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$certification certification',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: SkyOpsTheme.darkSurfaceColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: SkyOpsTheme.accentBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified,
              size: 20,
              color: SkyOpsTheme.accentBlue,
              semanticLabel: 'Verified',
            ),
            const SizedBox(width: 8),
            Text(
              certification,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: SkyOpsTheme.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
