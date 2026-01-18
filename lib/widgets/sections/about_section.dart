import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// About section explaining airline operation problems and SkyOpsHub's mission
/// Presents the value proposition and problem statement
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: ResponsiveWidget(
          mobile: _buildMobileLayout(context),
          desktop: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Problem statement
        Expanded(
          flex: 1,
          child: _buildProblemStatement(context),
        ),
        
        const SizedBox(width: 64),
        
        // Right side - Solution and mission
        Expanded(
          flex: 1,
          child: _buildSolutionStatement(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildProblemStatement(context),
        const SizedBox(height: 48),
        _buildSolutionStatement(context),
      ],
    );
  }

  Widget _buildProblemStatement(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'THE CHALLENGE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Problem title
        Text(
          'Airlines Face Complex Operational Challenges',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.headlineMedium?.color,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Problem description
        Text(
          'Modern airline operations involve countless moving parts - from flight scheduling and crew management to resource allocation and real-time disruption handling. Traditional systems struggle to optimize these interconnected processes, leading to:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            height: 1.6,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Problem points
        ..._buildProblemPoints(context),
      ],
    );
  }

  List<Widget> _buildProblemPoints(BuildContext context) {
    final problems = [
      'Inefficient resource utilization and scheduling conflicts',
      'Reactive rather than proactive disruption management',
      'Siloed systems that don\'t communicate effectively',
      'Manual processes prone to human error',
      'Limited visibility into operational performance',
    ];

    return problems.map((problem) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                problem,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSolutionStatement(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'OUR MISSION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Solution title
        Text(
          'Transforming Operations with AI Intelligence',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.headlineMedium?.color,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Mission description
        Text(
          'SkyOpsHub leverages cutting-edge artificial intelligence and optimization algorithms to revolutionize airline operations management. Our platform provides:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            height: 1.6,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Solution points
        ..._buildSolutionPoints(context),
        
        const SizedBox(height: 32),
        
        // Mission statement
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SkyOpsTheme.primaryBlue.withOpacity(0.05),
                SkyOpsTheme.accentBlue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SkyOpsTheme.primaryBlue.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Vision',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'To empower airlines with intelligent, data-driven solutions that simplify complex operations, reduce costs, and enhance operational efficiency while maintaining the highest standards of safety and reliability.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSolutionPoints(BuildContext context) {
    final solutions = [
      'Intelligent scheduling optimization and resource allocation',
      'Predictive analytics for proactive disruption management',
      'Unified platform integrating all operational systems',
      'Automated workflows reducing manual intervention',
      'Real-time dashboards with actionable insights',
    ];

    return solutions.map((solution) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.green.shade500,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                solution,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}