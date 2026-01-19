import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Hero section with animated content, gradient background, and CTAs
/// Displays product name, tagline, and primary/secondary action buttons
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: ResponsiveBreakpoints.isMobile(context) ? 600 : 700,
      ),
      decoration: BoxDecoration(
        gradient: SkyOpsTheme.primaryGradient(isDark),
      ),
      child: ResponsiveContainer(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ResponsiveWidget(
              mobile: _buildMobileLayout(),
              desktop: _buildDesktopLayout(),
            ),
          ),
        ),
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
        // Product name
        Text(
          'SkyOpsHub',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 48 : 64,
            letterSpacing: -1.5,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        
        const SizedBox(height: 16),
        
        // Tagline
        Text(
          'AI-Driven Intelligence for Smarter Airline Operations',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w400,
            fontSize: isMobile ? 20 : 28,
            height: 1.3,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        
        const SizedBox(height: 24),
        
        // Description
        Text(
          'Transform your airline operations with cutting-edge AI technology. '
          'Optimize schedules, reduce costs, and enhance efficiency with our '
          'comprehensive operations management platform.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: isMobile ? 16 : 18,
            height: 1.5,
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _buildSecondaryCTA(),
          ),
        ],
      );
    }
    
    return Row(
      children: [
        _buildPrimaryCTA(),
        const SizedBox(width: 16),
        _buildSecondaryCTA(),
      ],
    );
  }

  Widget _buildPrimaryCTA() {
    return ElevatedButton(
      onPressed: () => _launchURL('https://app.skyopshub.in'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: SkyOpsTheme.primaryBlue,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.rocket_launch, size: 20, color: SkyOpsTheme.primaryBlue),
          const SizedBox(width: 8),
          Text(
            'Explore the Platform',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: SkyOpsTheme.primaryBlue,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryCTA() {
    return OutlinedButton(
      onPressed: () => _launchURL('https://github.com/skyopshub'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.code, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'View GitHub',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroVisual() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: ResponsiveBreakpoints.isMobile(context) ? 200 : 300,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Image.asset(
            'assets/images/SkyOpsHub-logo.png',
            height: ResponsiveBreakpoints.isMobile(context) ? 120 : 180,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}