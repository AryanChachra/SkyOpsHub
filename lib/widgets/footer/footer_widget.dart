import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Professional footer with copyright and navigation links
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

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
            // Logo and company info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/SkyOpsHub-horizontal.png',
                  height: 32,
                  color: Colors.white,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Navigation links
            Wrap(
              spacing: 32,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildFooterLink(context, 'About'),
                _buildFooterLink(context, 'Features'),
                _buildFooterLink(context, 'GitHub'),
                _buildFooterLink(context, 'Privacy Policy'),
                _buildFooterLink(context, 'Terms of Service'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Copyright
            Text(
              '© ${DateTime.now().year} SkyOpsHub. All rights reserved.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextButton(
        onPressed: () {
          // Handle navigation
        },
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}