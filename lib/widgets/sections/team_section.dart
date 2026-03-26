import 'package:flutter/material.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/animation_helpers.dart';

/// Team and Founder Section
/// Displays founder story and team expertise with aviation operations focus
class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final isTablet = ResponsiveBreakpoints.isTablet(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: FadeSlideAnimation(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why SkyOps Hub was created',
                  style: textTheme.headlineLarge?.copyWith(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w700,
                    color: SkyOpsTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Combining AI expertise with a deep interest in airline operations',
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 16 : 18,
                    color: SkyOpsTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                _FounderStoryCard(isMobile: isMobile),
                const SizedBox(height: 64),
                _TeamGrid(isMobile: isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Founder story card with origin narrative
class _FounderStoryCard extends StatelessWidget {
  final bool isMobile;

  const _FounderStoryCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return HoverElevationCard(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        decoration: BoxDecoration(
          color: SkyOpsTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: SkyOpsTheme.primaryBlue.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: SkyOpsTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: SkyOpsTheme.primaryBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Our Origin Story',
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.w600,
                      color: SkyOpsTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'SkyOpsHub was started as an independent project driven by a strong interest in aviation and a background in AI and software engineering.',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 15 : 16,
                height: 1.6,
                color: SkyOpsTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'While exploring airline operations, it became clear that many critical processes, such as crew scheduling, aircraft rotations, and disruption recovery, are still highly manual and difficult to manage in real time.',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 15 : 16,
                height: 1.6,
                color: SkyOpsTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Existing tools often struggle to adapt quickly to operational changes, leading to cascading delays, inefficient resource utilization, and complex coordination across teams.',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 15 : 16,
                height: 1.6,
                color: SkyOpsTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SkyOpsHub is being developed to address these challenges by applying AI-driven optimization to airline operations, helping generate more efficient schedules while respecting operational constraints and regulatory requirements.',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 15 : 16,
                height: 1.6,
                color: SkyOpsTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Team grid with three categories
class _TeamGrid extends StatelessWidget {
  final bool isMobile;

  const _TeamGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About the Founder',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.w700,
            color: SkyOpsTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: _TeamCategoryCard(
            icon: Icons.person,
            expertiseParagraphs: const [
              'SkyOps Hub is being developed by a software engineer with a background in AI and data science, currently working on agentic systems in the industry.',
              'With a strong personal interest in aviation, the idea for SkyOpsHub came from exploring how airline operations function in practice, particularly in areas like crew scheduling, aircraft rotations, and disruption recovery.It became clear that many of these processes are still heavily manual and difficult to adapt in real time.',
              'Driven by this understanding, the project focuses on applying modern AI and optimization techniques to address these challenges.The goal is to build a practical and reliable system that can support real-world airline operations, helping improve scheduling efficiency, resource utilization, and operational decision-making.',
              'SkyOpsHub is currently in development, with a focus on building a system that is both technically robust and aligned with the realities of airline operations.',
            ],
            isMobile: isMobile,
          ),
        ),
      ],
    );
  }
}

/// Team category card
class _TeamCategoryCard extends StatelessWidget {
  final IconData icon;
  final List<String> expertiseParagraphs;
  final bool isMobile;

  const _TeamCategoryCard({
    required this.icon,
    required this.expertiseParagraphs,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return HoverElevationCard(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: SkyOpsTheme.textSecondary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: SkyOpsTheme.accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: SkyOpsTheme.accentBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Aryan Chachra',
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: SkyOpsTheme.accentBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...expertiseParagraphs.asMap().entries.map((entry) {
              final index = entry.key;
              final paragraph = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < expertiseParagraphs.length - 1 ? 16 : 0,
                ),
                child: Text(
                  paragraph,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: isMobile ? 15 : 16,
                    height: 1.6,
                    color: SkyOpsTheme.textPrimary,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
