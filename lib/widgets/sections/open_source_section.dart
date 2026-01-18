import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Open source section with GitHub repository links
class OpenSourceSection extends StatelessWidget {
  const OpenSourceSection({super.key});

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
              'Open Source & GitHub',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: SkyOpsTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Explore our open-source contributions and development repositories',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: SkyOpsTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _launchURL('https://github.com/skyopshub'),
              icon: const Icon(Icons.code),
              label: const Text('View on GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}