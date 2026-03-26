import 'package:flutter/material.dart';
import '../../config/redesign_config.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';
import '../cards/case_study_card.dart';

/// Case Studies Section displaying aviation operational scenarios
/// Shows at least 3 case studies with varied layouts (alternating standard/reversed)
class CaseStudiesSection extends StatelessWidget {
  const CaseStudiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SkyOpsTheme.backgroundColor,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context),
            const SizedBox(height: 48),
            _buildCaseStudiesList(context),
          ],
        ),
      ),
    );
  }

  /// Build section header with title and description
  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Example Operational Scenarios',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: SkyOpsTheme.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: ResponsiveBreakpoints.isMobile(context) ? 34 : 42,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Illustrative examples based on common airline operational challenges and how SkyOpsHub addresses them.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: SkyOpsTheme.textSecondary,
                height: 1.6,
                fontSize: ResponsiveBreakpoints.isMobile(context) ? 18 : 20,
              ),
        ),
      ],
    );
  }

  /// Build list of case studies with alternating layouts
  Widget _buildCaseStudiesList(BuildContext context) {
    return Column(
      children: List.generate(
        RedesignConfig.caseStudies.length,
        (index) {
          final caseStudy = RedesignConfig.caseStudies[index];
          final isReversed = index % 2 == 1; // Alternate layouts

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < RedesignConfig.caseStudies.length - 1 ? 64 : 0,
            ),
            child: CaseStudyCard(
              caseStudy: caseStudy,
              reversed: isReversed,
            ),
          );
        },
      ),
    );
  }
}
