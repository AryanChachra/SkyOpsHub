import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';
import '../../utils/animation_helpers.dart';

/// Reusable CTA section component with dark and light background variants
/// Supports value-driven messaging with primary and secondary CTA buttons
/// Implements responsive layout (stacked for mobile, row for desktop)
class CTASection extends StatelessWidget {
  final String headline;
  final String description;
  final String primaryCTAText;
  final String primaryCTAUrl;
  final String? secondaryCTAText;
  final String? secondaryCTAUrl;
  final bool isDarkBackground;
  final IconData? primaryIcon;
  final IconData? secondaryIcon;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool showButtons;

  const CTASection({
    super.key,
    required this.headline,
    required this.description,
    required this.primaryCTAText,
    required this.primaryCTAUrl,
    this.secondaryCTAText,
    this.secondaryCTAUrl,
    this.isDarkBackground = false,
    this.primaryIcon,
    this.secondaryIcon,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.showButtons = true,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final textColor = isDarkBackground ? Colors.white : SkyOpsTheme.textPrimary;
    final descriptionColor = isDarkBackground
        ? Colors.white.withOpacity(0.85)
        : SkyOpsTheme.textSecondary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDarkBackground ? SkyOpsTheme.darkSectionGradient : null,
        color: isDarkBackground ? null : SkyOpsTheme.backgroundColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: isMobile ? 48 : 80,
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveBreakpoints.getMaxContentWidth(context),
          ),
          child: FadeSlideAnimation(
            child: isMobile
                ? _buildMobileLayout(context, textColor, descriptionColor)
                : _buildDesktopLayout(context, textColor, descriptionColor),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
      BuildContext context, Color textColor, Color descriptionColor) {
    if (!showButtons) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            headline,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: descriptionColor,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Content
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: descriptionColor,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 48),

        // Right side - CTA Buttons
        Expanded(
          flex: 2,
          child: _buildCTAButtons(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, Color textColor, Color descriptionColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          headline,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.2,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: descriptionColor,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        if (showButtons) ...[
          const SizedBox(height: 32),
          _buildCTAButtons(context),
        ],
      ],
    );
  }

  Widget _buildCTAButtons(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildPrimaryCTA(context),
          ),
          if (secondaryCTAText != null && secondaryCTAUrl != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _buildSecondaryCTA(context),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPrimaryCTA(context),
        if (secondaryCTAText != null && secondaryCTAUrl != null) ...[
          const SizedBox(height: 16),
          _buildSecondaryCTA(context),
        ],
      ],
    );
  }

  Widget _buildPrimaryCTA(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return ElevatedButton(
      onPressed: onPrimaryPressed ?? () => _launchURL(primaryCTAUrl),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isDarkBackground ? SkyOpsTheme.accentBlue : SkyOpsTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: (isDarkBackground
                ? SkyOpsTheme.accentBlue
                : SkyOpsTheme.primaryBlue)
            .withOpacity(0.3),
        padding: ResponsiveBreakpoints.getButtonPadding(context),
        minimumSize:
            isMobile ? const Size(double.infinity, 44) : const Size(200, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveBreakpoints.getBorderRadius(context),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (primaryIcon != null) ...[
            Icon(
              primaryIcon,
              size: ResponsiveBreakpoints.getIconSize(context, base: 20),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              primaryCTAText,
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
    );
  }

  Widget _buildSecondaryCTA(BuildContext context) {
    if (secondaryCTAText == null || secondaryCTAUrl == null) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return OutlinedButton(
      onPressed: onSecondaryPressed ?? () => _launchURL(secondaryCTAUrl!),
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isDarkBackground ? Colors.white : SkyOpsTheme.primaryBlue,
        side: BorderSide(
          color: isDarkBackground ? Colors.white : SkyOpsTheme.primaryBlue,
          width: 2,
        ),
        padding: ResponsiveBreakpoints.getButtonPadding(context),
        minimumSize:
            isMobile ? const Size(double.infinity, 44) : const Size(200, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveBreakpoints.getBorderRadius(context),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (secondaryIcon != null) ...[
            Icon(
              secondaryIcon,
              size: ResponsiveBreakpoints.getIconSize(context, base: 20),
              color: isDarkBackground ? Colors.white : SkyOpsTheme.primaryBlue,
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              secondaryCTAText!,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    isDarkBackground ? Colors.white : SkyOpsTheme.primaryBlue,
                fontSize: isMobile ? 15 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
