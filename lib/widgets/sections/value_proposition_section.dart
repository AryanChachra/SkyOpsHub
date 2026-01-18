import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Value proposition section explaining why airlines choose SkyOpsHub
/// Highlights specific benefits and competitive advantages
class ValuePropositionSection extends StatelessWidget {
  const ValuePropositionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SkyOpsTheme.backgroundColor,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _buildSectionHeader(context),
            const SizedBox(height: 48),
            _buildValuePropositions(context),
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
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'WHY CHOOSE US',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Section title
        Text(
          'Why Airlines Choose SkyOpsHub',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: SkyOpsTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Section description
        Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            'Leading airlines worldwide trust SkyOpsHub to transform their operations. Discover the competitive advantages that set us apart in the aviation technology landscape.',
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

  Widget _buildValuePropositions(BuildContext context) {
    return ResponsiveWidget(
      mobile: _buildMobileLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(
            children: [
              _buildValueCard(
                context,
                'Proven ROI',
                'Average 25% reduction in operational costs within the first year of implementation.',
                Icons.trending_up,
                Colors.green,
              ),
              const SizedBox(height: 24),
              _buildValueCard(
                context,
                'Enterprise Security',
                'Bank-level security with SOC 2 compliance and end-to-end encryption.',
                Icons.security,
                Colors.blue,
              ),
              const SizedBox(height: 24),
              _buildValueCard(
                context,
                'Seamless Integration',
                'Easy integration with existing airline systems and third-party platforms.',
                Icons.integration_instructions,
                Colors.purple,
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 32),
        
        // Right column
        Expanded(
          child: Column(
            children: [
              _buildValueCard(
                context,
                '24/7 Expert Support',
                'Dedicated aviation industry experts providing round-the-clock technical support.',
                Icons.support_agent,
                Colors.orange,
              ),
              const SizedBox(height: 24),
              _buildValueCard(
                context,
                'Scalable Architecture',
                'Cloud-native platform that scales from regional carriers to global airlines.',
                Icons.cloud,
                Colors.teal,
              ),
              const SizedBox(height: 24),
              _buildValueCard(
                context,
                'Continuous Innovation',
                'Regular updates with latest AI advancements and industry best practices.',
                Icons.auto_awesome,
                Colors.indigo,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final valueProps = [
      ValueProp('Proven ROI', 'Average 25% reduction in operational costs within the first year of implementation.', Icons.trending_up, Colors.green),
      ValueProp('24/7 Expert Support', 'Dedicated aviation industry experts providing round-the-clock technical support.', Icons.support_agent, Colors.orange),
      ValueProp('Enterprise Security', 'Bank-level security with SOC 2 compliance and end-to-end encryption.', Icons.security, Colors.blue),
      ValueProp('Scalable Architecture', 'Cloud-native platform that scales from regional carriers to global airlines.', Icons.cloud, Colors.teal),
      ValueProp('Seamless Integration', 'Easy integration with existing airline systems and third-party platforms.', Icons.integration_instructions, Colors.purple),
      ValueProp('Continuous Innovation', 'Regular updates with latest AI advancements and industry best practices.', Icons.auto_awesome, Colors.indigo),
    ];

    return Column(
      children: valueProps.map((prop) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildValueCard(
            context,
            prop.title,
            prop.description,
            prop.icon,
            prop.color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValueCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: SkyOpsTheme.cardShadow,
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SkyOpsTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: SkyOpsTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ValueProp {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  
  ValueProp(this.title, this.description, this.icon, this.color);
}