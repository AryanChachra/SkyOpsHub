import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Product links section with dedicated access buttons
class ProductLinksSection extends StatelessWidget {
  const ProductLinksSection({super.key});

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
      color: Colors.white,
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              'Access SkyOpsHub Platform',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: SkyOpsTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _launchURL('https://app.skyopshub.in'),
                  child: const Text('Launch Platform'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => _launchURL('https://github.com/skyopshub'),
                  child: const Text('View Source'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}