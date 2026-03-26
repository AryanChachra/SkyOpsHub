import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Professional footer with copyright and navigation links
class FooterWidget extends StatelessWidget {
  final Function(String)? onNavigate;

  const FooterWidget({super.key, this.onNavigate});

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  SkyOpsTheme.darkSectionBackground,
                  SkyOpsTheme.darkHeroBackground
                ]
              : [SkyOpsTheme.primaryBlue, const Color(0xFF082A6B)],
        ),
      ),
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
        _buildConnect(context),
      ],
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Semantics(
          label: 'SkyOpsHub company logo',
          image: true,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Image.asset(
              'assets/images/SkyOpsHub-horizontal-wbg.png',
              height: 48,
              fit: BoxFit.contain,
              semanticLabel: 'SkyOpsHub logo',
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'AI-assisted scheduling for modern airline operations',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
        ),

        const SizedBox(height: 8),

        Text(
          'Plan and manage aircraft, crew, and ground resources more efficiently while maintaining regulatory compliance.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
                height: 1.4,
                fontSize: 12,
              ),
        ),
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
              () => _launchURL(
                  'https://www.linkedin.com/in/aryan-chachra-519927232'),
            ),
            const SizedBox(width: 8),
            _buildSocialButton(
              context,
              Icons.code,
              'GitHub',
              () => _launchURL('https://github.com/AryanChachra/SkyOpsHub'),
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
              color: SkyOpsTheme.accentBlue,
              size: 14,
            ),
            const SizedBox(width: 6),
            Semantics(
              label: 'Send email to admin@skyopshub.in',
              button: true,
              child: InkWell(
                onTap: () => _launchURL('mailto:admin@skyopshub.in'),
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  'admin@skyopshub.in',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopBottom(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '© ${DateTime.now().year} SkyOpsHub. All rights reserved.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
      ),
    );
  }

  Widget _buildMobileBottom(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} SkyOpsHub. All rights reserved.',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooterLink(
      BuildContext context, String text, VoidCallback onPressed) {
    return Semantics(
      label: text,
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.transparent,
                ),
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
    return Semantics(
      label: 'Visit SkyOpsHub on $tooltip',
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          decoration: BoxDecoration(
            color: SkyOpsTheme.accentBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: SkyOpsTheme.accentBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: SkyOpsTheme.accentBlue,
            size: 18,
          ),
        ),
      ),
    );
  }
}
