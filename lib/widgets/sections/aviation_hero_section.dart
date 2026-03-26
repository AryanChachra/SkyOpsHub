import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../pages/demo_request_page.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../utils/aviation_image_assets.dart';
import '../../theme/skyops_theme.dart';
import '../aviation_motifs/aviation_motifs.dart';

/// Aviation-themed hero section with dark gradient background and aviation motifs
/// Displays aviation-specific value proposition with operational context
class AviationHeroSection extends StatefulWidget {
  final VoidCallback? onRequestDemo;

  const AviationHeroSection({
    super.key,
    this.onRequestDemo,
  });

  @override
  State<AviationHeroSection> createState() => _AviationHeroSectionState();
}

class _AviationHeroSectionState extends State<AviationHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: ResponsiveBreakpoints.isMobile(context) ? 600 : 700,
      ),
      decoration: BoxDecoration(
        gradient: SkyOpsTheme.darkSectionGradient,
      ),
      child: Stack(
        children: [
          // Aviation motifs layer
          Positioned.fill(
            child: AviationMotifs.layered(
              motifs: [
                AviationMotifs.radarGrid(
                  color: Colors.white,
                  opacity: 0.08,
                ),
                AviationMotifs.flightPaths(
                  color: Colors.white,
                  opacity: 0.1,
                ),
              ],
            ),
          ),

          // Content layer
          ResponsiveContainer(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Semantics(
                  label: 'Hero section: SkyOpsHub aviation operations platform',
                  child: ResponsiveWidget(
                    mobile: _buildMobileLayout(),
                    desktop: _buildDesktopLayout(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Content
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContent(),
            ],
          ),
        ),

        const SizedBox(width: 48),

        // Right side - Logo/Visual
        Expanded(
          flex: 2,
          child: _buildHeroVisual(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeroVisual(),
        const SizedBox(height: 32),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Column(
      crossAxisAlignment: ResponsiveBreakpoints.isMobile(context)
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Headline
        Text(
          'AI-assisted scheduling for modern airline operations',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 36 : 56,
                letterSpacing: -1.5,
                height: 1.1,
              ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 20),

        // Subheadline
        Text(
          'Plan and manage aircraft, crew, and ground resources more efficiently while maintaining regulatory compliance.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w400,
                fontSize: isMobile ? 18 : 24,
                height: 1.3,
              ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 24),

        // Operational description
        Text(
          'SkyOps Hub helps airlines generate optimized schedules based on fleet size, crew availability, route networks, and operational constraints. '
          'The platform is designed to support compliance with crew duty regulations and aircraft maintenance requirements, while improving resource utilization across operations.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontSize: isMobile ? 16 : 18,
                height: 1.6,
              ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 40),

        // CTA Buttons
        _buildCTAButtons(),
      ],
    );
  }

  Widget _buildCTAButtons() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildPrimaryCTA(),
          ),
          // const SizedBox(height: 16),
          // SizedBox(
          //   width: double.infinity,
          //   child: _buildSecondaryCTA(),
          // ),
        ],
      );
    }

    return Row(
      children: [
        _buildPrimaryCTA(),
        // const SizedBox(width: 16),
        // _buildSecondaryCTA(),
      ],
    );
  }

  Widget _buildPrimaryCTA() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Semantics(
      label: 'Request Demo',
      button: true,
      child: ElevatedButton(
        onPressed: widget.onRequestDemo ?? () => DemoRequestPage.open(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: SkyOpsTheme.accentBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: SkyOpsTheme.accentBlue.withOpacity(0.3),
          padding: ResponsiveBreakpoints.getButtonPadding(context),
          minimumSize:
              isMobile ? const Size(double.infinity, 44) : const Size(44, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveBreakpoints.getBorderRadius(context),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flight_takeoff,
              size: ResponsiveBreakpoints.getIconSize(context, base: 20),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'Request Demo',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: isMobile ? 15 : 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryCTA() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Semantics(
      label: 'See How It Works',
      button: true,
      child: OutlinedButton(
        onPressed: () => _launchURL('https://app.skyopshub.in/demo'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          padding: ResponsiveBreakpoints.getButtonPadding(context),
          minimumSize:
              isMobile ? const Size(double.infinity, 44) : const Size(44, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveBreakpoints.getBorderRadius(context),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: ResponsiveBreakpoints.getIconSize(context, base: 20),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'See How It Works',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: isMobile ? 15 : 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroVisual() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: isMobile ? 250 : 400,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: AviationImageAssets.buildHeroVisual(
            context: context,
            isMobile: isMobile,
          ),
        ),
      ),
    );
  }
}
