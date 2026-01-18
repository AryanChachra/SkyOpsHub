import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Contact section with social media links and contact information
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
      color: SkyOpsTheme.backgroundColor,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              'Get in Touch',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: SkyOpsTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'contact@skyopshub.in',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: SkyOpsTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _launchURL('https://linkedin.com/company/skyopshub'),
                  icon: const Icon(Icons.business),
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _launchURL('https://github.com/skyopshub'),
                  icon: const Icon(Icons.code),
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _launchURL('https://twitter.com/skyopshub'),
                  icon: const Icon(Icons.alternate_email),
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}