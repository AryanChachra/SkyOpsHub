import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';
import '../cards/feature_card.dart';
import '../../models/feature_data.dart';

/// Features section showcasing six key features with icons and descriptions
/// Uses responsive grid layout (1-2-3 columns based on screen size)
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static const List<FeatureData> _features = [
    FeatureData(
      title: 'AI-Powered Scheduling Optimization',
      description: 'Advanced algorithms optimize flight schedules and resource allocation, reducing conflicts and maximizing efficiency across your entire operation.',
      icon: Icons.schedule,
    ),
    FeatureData(
      title: 'Predictive Maintenance Analytics',
      description: 'Machine learning models predict maintenance needs before issues occur, minimizing downtime and ensuring fleet reliability.',
      icon: Icons.build_circle,
    ),
    FeatureData(
      title: 'Real-Time Disruption Management',
      description: 'Intelligent systems automatically detect and respond to operational disruptions with optimized recovery solutions.',
      icon: Icons.warning_amber,
    ),
    FeatureData(
      title: 'Crew Management Automation',
      description: 'Streamline crew scheduling, training, and compliance tracking with automated workflows and intelligent assignments.',
      icon: Icons.people,
    ),
    FeatureData(
      title: 'Performance Analytics Dashboard',
      description: 'Comprehensive dashboards provide real-time insights into operational metrics, KPIs, and performance trends.',
      icon: Icons.analytics,
    ),
    FeatureData(
      title: 'Integrated Communication Hub',
      description: 'Centralized communication platform connecting all stakeholders with real-time updates and collaborative tools.',
      icon: Icons.hub,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _buildSectionHeader(context),
            const SizedBox(height: 48),
            _buildFeaturesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      children: [
        // Section badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: SkyOpsTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'KEY FEATURES',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: SkyOpsTheme.primaryBlue,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Section title
        Text(
          'Comprehensive Airline Operations Management',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: SkyOpsTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Section description
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Discover how SkyOpsHub\'s intelligent features transform every aspect of your airline operations, from scheduling to maintenance, with cutting-edge AI technology.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: SkyOpsTheme.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final columns = ResponsiveBreakpoints.getGridColumns(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: _features.map((feature) {
            double cardWidth;
            
            if (columns == 1) {
              cardWidth = constraints.maxWidth;
            } else if (columns == 2) {
              cardWidth = (constraints.maxWidth - 24) / 2;
            } else {
              cardWidth = (constraints.maxWidth - 48) / 3;
            }
            
            return SizedBox(
              width: cardWidth,
              child: FeatureCard(feature: feature),
            );
          }).toList(),
        );
      },
    );
  }
}