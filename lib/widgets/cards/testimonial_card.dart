import 'package:flutter/material.dart';
import '../../models/testimonial_data.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/animation_helpers.dart';

/// Testimonial Card widget displaying quote, attribution, and operational context
/// Includes role, airline type, and context for credibility
class TestimonialCard extends StatelessWidget {
  final TestimonialData testimonial;

  const TestimonialCard({
    super.key,
    required this.testimonial,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Testimonial from ${testimonial.name}, ${testimonial.role} at ${testimonial.airlineType}',
      child: HoverElevationCard(
        child: Container(
          margin: ResponsiveBreakpoints.getResponsiveMargin(context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: SkyOpsTheme.cardShadow,
          ),
          child: Padding(
            padding: ResponsiveBreakpoints.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuoteIcon(context),
                const SizedBox(height: 16),
                _buildQuote(context),
                const SizedBox(height: 24),
                _buildContextBox(context),
                const SizedBox(height: 24),
                _buildAttribution(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build quote icon at the top
  Widget _buildQuoteIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SkyOpsTheme.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.format_quote,
        size: 32,
        color: SkyOpsTheme.accentBlue,
      ),
    );
  }

  /// Build the testimonial quote text
  Widget _buildQuote(BuildContext context) {
    return Text(
      testimonial.quote,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: SkyOpsTheme.textPrimary,
        height: 1.6,
        fontSize: ResponsiveBreakpoints.isMobile(context) ? 15 : 16,
      ),
    );
  }

  /// Build context box with operational context
  Widget _buildContextBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SkyOpsTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SkyOpsTheme.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: SkyOpsTheme.primaryBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Context',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: SkyOpsTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  testimonial.context,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SkyOpsTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build attribution with name, role, and airline type
  Widget _buildAttribution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          testimonial.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: SkyOpsTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          testimonial.role,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SkyOpsTheme.primaryBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          testimonial.airlineType,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: SkyOpsTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
