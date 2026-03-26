import 'package:flutter/material.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/animation_helpers.dart';

/// Customer Proof Section displaying airline logos and trust indicators
/// Implements white background with "Trusted by Leading Airlines" headline
/// Features asymmetric logo layout with varied sizes (120px-160px width)
class CustomerProofSection extends StatelessWidget {
  const CustomerProofSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveBreakpoints.isMobile(context) ? 16 : 48,
          vertical: ResponsiveBreakpoints.isMobile(context) ? 48 : 80,
        ),
        child: FadeSlideAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Headline
              Text(
                'Trusted by Leading Airlines',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: SkyOpsTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Customer Logos Row with asymmetric layout
              const CustomerLogosRow(),
              
              const SizedBox(height: 40),
              
              // Subtitle
              Text(
                'From regional carriers to international airlines, operations teams rely on SkyOpsHub',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: SkyOpsTheme.textSecondary,
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

/// Customer Logos Row widget with asymmetric layout
/// Displays airline logos with varied sizes (120px-160px width)
class CustomerLogosRow extends StatelessWidget {
  const CustomerLogosRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    
    // Define airline logos with varied sizes for asymmetric layout
    final logos = [
      _LogoItem(name: 'Airline 1', width: 140),
      _LogoItem(name: 'Airline 2', width: 160),
      _LogoItem(name: 'Airline 3', width: 120),
      _LogoItem(name: 'Airline 4', width: 150),
      _LogoItem(name: 'Airline 5', width: 135),
    ];

    if (isMobile) {
      // Mobile: Display logos in a grid with 2 columns
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 32,
        children: logos.map((logo) => _buildLogoPlaceholder(context, logo)).toList(),
      );
    } else {
      // Desktop/Tablet: Display logos in asymmetric row layout
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 40,
        runSpacing: 32,
        children: logos.map((logo) => _buildLogoPlaceholder(context, logo)).toList(),
      );
    }
  }

  Widget _buildLogoPlaceholder(BuildContext context, _LogoItem logo) {
    return Semantics(
      label: '${logo.name} - airline customer',
      image: true,
      child: HoverElevationCard(
        child: Container(
          width: logo.width,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              logo.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SkyOpsTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal class to represent a logo item with varied width
class _LogoItem {
  final String name;
  final double width;

  _LogoItem({required this.name, required this.width});
}
