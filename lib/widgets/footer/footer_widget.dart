import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Professional footer with copyright and navigation links
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

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
      color: isDark ? SkyOpsTheme.darkSurfaceColor : SkyOpsTheme.textPrimary,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SizedBox(height: 32),
            
            // Main footer content
            ResponsiveWidget(
              mobile: _buildMobileFooter(context),
              desktop: _buildDesktopFooter(context),
            ),
            
            const SizedBox(height: 24),
            
            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            
            const SizedBox(height: 16),
            
            // Bottom section
            ResponsiveWidget(
              mobile: _buildMobileBottom(context),
              desktop: _buildDesktopBottom(context),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company info
        Expanded(
          flex: 2,
          child: _buildCompanyInfo(context),
        ),
        
        const SizedBox(width: 24),
        
        // Quick links
        Expanded(
          child: _buildQuickLinks(context),
        ),
        
        const SizedBox(width: 24),
        
        // Resources
        Expanded(
          child: _buildResources(context),
        ),
        
        const SizedBox(width: 24),
        
        // Connect
        Expanded(
          child: _buildConnect(context),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      children: [
        _buildCompanyInfo(context),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildQuickLinks(context)),
            const SizedBox(width: 16),
            Expanded(child: _buildResources(context)),
          ],
        ),
        const SizedBox(height: 24),
        _buildConnect(context),
      ],
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Image.asset(
            'assets/images/SkyOpsHub-horizontal-wbg.png',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'AI-Driven Intelligence for Smarter Airline Operations',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Transforming aviation operations with cutting-edge AI technology.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.7),
            height: 1.4,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildFooterLink(context, 'About Us', () {}),
        _buildFooterLink(context, 'Features', () {}),
        _buildFooterLink(context, 'Technology', () {}),
        _buildFooterLink(context, 'Contact', () {}),
      ],
    );
  }

  Widget _buildResources(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resources',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildFooterLink(context, 'Platform Demo', () => _launchURL('https://app.skyopshub.in')),
        _buildFooterLink(context, 'GitHub', () => _launchURL('https://github.com/skyopshub')),
        _buildFooterLink(context, 'Documentation', () {}),
        _buildFooterLink(context, 'API Reference', () {}),
      ],
    );
  }

  Widget _buildConnect(BuildContext context) {
    return Column(
      crossAxisAlignment: ResponsiveBreakpoints.isMobile(context) 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Connect With Us',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Social media buttons
        Row(
          mainAxisAlignment: ResponsiveBreakpoints.isMobile(context) 
              ? MainAxisAlignment.center 
              : MainAxisAlignment.start,
          children: [
            _buildSocialButton(
              context,
              Icons.business,
              'LinkedIn',
              () => _launchURL('https://linkedin.com/company/skyopshub'),
            ),
            const SizedBox(width: 8),
            _buildSocialButton(
              context,
              Icons.code,
              'GitHub',
              () => _launchURL('https://github.com/skyopshub'),
            ),
            const SizedBox(width: 8),
            _buildSocialButton(
              context,
              Icons.alternate_email,
              'Twitter',
              () => _launchURL('https://twitter.com/skyopshub'),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Contact info
        Wrap(
          alignment: ResponsiveBreakpoints.isMobile(context) 
              ? WrapAlignment.center 
              : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.email,
              color: Colors.white.withOpacity(0.7),
              size: 14,
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _launchURL('mailto:contact@skyopshub.in'),
              child: Text(
                'contact@skyopshub.in',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopBottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '© ${DateTime.now().year} SkyOpsHub. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ),
        Wrap(
          spacing: 16,
          children: [
            _buildFooterLink(context, 'Privacy Policy', () {}),
            _buildFooterLink(context, 'Terms of Service', () {}),
            _buildFooterLink(context, 'Cookie Policy', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileBottom(BuildContext context) {
    return Column(
      children: [
        Text(
          '© ${DateTime.now().year} SkyOpsHub. All rights reserved.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _buildFooterLink(context, 'Privacy Policy', () {}),
            _buildFooterLink(context, 'Terms of Service', () {}),
            _buildFooterLink(context, 'Cookie Policy', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
            decoration: TextDecoration.underline,
            decorationColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),
      ),
    );
  }
}