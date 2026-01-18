import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Technology stack section highlighting technical credibility
class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              'Technology Stack',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: SkyOpsTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                _buildTechItem(context, 'Flutter Web', 'Frontend'),
                _buildTechItem(context, 'FastAPI', 'Backend'),
                _buildTechItem(context, 'AI Engines', 'Intelligence'),
                _buildTechItem(context, 'Cloud Infrastructure', 'Scalability'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechItem(BuildContext context, String name, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SkyOpsTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: SkyOpsTheme.primaryBlue,
            ),
          ),
          Text(
            category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: SkyOpsTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}