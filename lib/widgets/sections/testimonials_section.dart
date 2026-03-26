import 'package:flutter/material.dart';
import '../../config/redesign_config.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/animation_helpers.dart';
import '../cards/testimonial_card.dart';

/// Testimonials Section displaying customer testimonials in grid layout
/// Responsive layout: 2 columns for desktop, 1 column for mobile
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SkyOpsTheme.backgroundColor,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveBreakpoints.getMaxContentWidth(context),
          ),
          padding: ResponsiveBreakpoints.getResponsivePadding(context),
          child: FadeSlideAnimation(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, base: 48)),
                _buildTestimonialsGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build section header with title
  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Operations Teams Say',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: SkyOpsTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: ResponsiveBreakpoints.isMobile(context) ? 28 : 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Real feedback from airline professionals using SkyOpsHub daily',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: SkyOpsTheme.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// Build testimonials grid with responsive layout
  Widget _buildTestimonialsGrid(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    
    if (isMobile) {
      // Single column layout for mobile
      return Column(
        children: RedesignConfig.testimonials
            .map((testimonial) => TestimonialCard(testimonial: testimonial))
            .toList(),
      );
    } else {
      // Two column grid layout for desktop/tablet
      return _buildTwoColumnGrid(context);
    }
  }

  /// Build two-column grid layout for desktop/tablet
  Widget _buildTwoColumnGrid(BuildContext context) {
    final testimonials = RedesignConfig.testimonials;
    final rows = <Widget>[];
    
    for (int i = 0; i < testimonials.length; i += 2) {
      final leftTestimonial = testimonials[i];
      final rightTestimonial = i + 1 < testimonials.length ? testimonials[i + 1] : null;
      
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TestimonialCard(testimonial: leftTestimonial),
            ),
            if (rightTestimonial != null) ...[
              const SizedBox(width: 24),
              Expanded(
                child: TestimonialCard(testimonial: rightTestimonial),
              ),
            ] else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      
      if (i + 2 < testimonials.length) {
        rows.add(const SizedBox(height: 24));
      }
    }
    
    return Column(children: rows);
  }
}
