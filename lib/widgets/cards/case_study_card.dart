import 'package:flutter/material.dart';
import '../../models/case_study_data.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/animation_helpers.dart';

/// Case Study Card widget displaying problem-solution-outcome structure
/// Supports standard and reversed layouts for visual variety
class CaseStudyCard extends StatelessWidget {
  final CaseStudyData caseStudy;
  final bool reversed;

  const CaseStudyCard({
    super.key,
    required this.caseStudy,
    this.reversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Semantics(
      label:
          'Case study: ${caseStudy.airlineType} - ${caseStudy.metricValue} ${caseStudy.metricLabel}',
      child: FadeSlideAnimation(
        child: Container(
          margin: ResponsiveBreakpoints.getResponsiveMargin(context),
          child: isMobile
              ? _buildStackedLayout(context)
              : _buildSideBySideLayout(context),
        ),
      ),
    );
  }

  /// Build stacked layout for mobile devices
  Widget _buildStackedLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAirlineTypeBadge(context),
        const SizedBox(height: 24),
        _buildContentSection(context),
      ],
    );
  }

  /// Build side-by-side layout for desktop/tablet
  Widget _buildSideBySideLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAirlineTypeBadge(context),
        const SizedBox(height: 32),
        _buildContentSection(context),
      ],
    );
  }

  /// Build airline type badge at the top
  Widget _buildAirlineTypeBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: SkyOpsTheme.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SkyOpsTheme.accentBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        caseStudy.airlineType,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: SkyOpsTheme.accentBlue,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveBreakpoints.isMobile(context) ? 16 : 18,
            ),
      ),
    );
  }

  /// Build content section with problem-solution-outcome structure
  Widget _buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContentBlock(
          context,
          title: 'Problem',
          content: caseStudy.problemStatement,
          icon: Icons.error_outline,
        ),
        const SizedBox(height: 24),
        _buildContentBlock(
          context,
          title: 'Solution',
          content: caseStudy.solutionApproach,
          icon: Icons.lightbulb_outline,
        ),
        const SizedBox(height: 24),
        _buildContentBlock(
          context,
          title: 'Result',
          content: caseStudy.outcome,
          icon: Icons.check_circle_outline,
        ),
      ],
    );
  }

  /// Build individual content block with icon and text
  Widget _buildContentBlock(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: SkyOpsTheme.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: SkyOpsTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveBreakpoints.isMobile(context) ? 20 : 22,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SkyOpsTheme.textPrimary,
                height: 1.6,
                fontSize: ResponsiveBreakpoints.isMobile(context) ? 17 : 19,
              ),
        ),
      ],
    );
  }
}
