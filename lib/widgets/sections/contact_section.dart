import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../pages/demo_request_page.dart';
import '../../utils/responsive_breakpoints.dart';

/// Homepage contact section that launches the dedicated demo request page
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _openEmailComposer() async {
    const gmailComposeUrl =
        'https://mail.google.com/mail/?view=cm&fs=1&to=admin@skyopshub.in';

    try {
      await _launchURL(gmailComposeUrl);
    } catch (_) {
      await _launchURL('mailto:admin@skyopshub.in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
        ),
      ),
      padding: ResponsiveBreakpoints.getSafePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _buildSectionHeader(context),
            SizedBox(
              height:
                  ResponsiveBreakpoints.getResponsiveSpacing(context, base: 32),
            ),
            isMobile
                ? Column(
                    children: [
                      _buildDemoRequestCard(context, isMobile),
                      const SizedBox(height: 20),
                      _buildConnectCard(context),
                    ],
                  )
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildDemoRequestCard(context, isMobile),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: _buildConnectCard(context),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Request a personalized demo and we’ll get back to you within 24–48 hours.',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 16),
        // ConstrainedBox(
        //   constraints: const BoxConstraints(maxWidth: 700),
        //   child: Text(
        //     'Request a personalized demo and we’ll get back to you within 24–48 hours.',
        //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //           height: 1.6,
        //           fontSize: 18,
        //         ),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFormHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.10),
            Theme.of(context).colorScheme.primary.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.description_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submit Your Demo Request',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                // const SizedBox(height: 4),
                // Text(
                //   'Request a personalized demo and we’ll get back to you within 24–48 hours.',
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //         height: 1.5,
                //       ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoRequestCard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFormHeader(context),
          // const SizedBox(height: 20),
          // Text(
          //   'The demo request form now opens on a dedicated page for a smoother experience while filling it out.',
          //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //         height: 1.6,
          //       ),
          //   textAlign: TextAlign.center,
          // ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => DemoRequestPage.open(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 16 : 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Open Demo Request Form',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Prefer to reach out directly?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _openEmailComposer,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Email at admin@skyopshub.in',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      decoration: TextDecoration.underline,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D3A5C),
            Color(0xFF173250),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2A78C8).withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B3D91).withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.connect_without_contact,
            size: 34,
            color: Colors.lightBlue.shade300,
          ),
          const SizedBox(height: 14),
          Text(
            'Connect & Follow',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 8),
          // Text(
          //   'Stay updated with latest features and industry insights',
          //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //         color: Colors.white.withOpacity(0.82),
          //         height: 1.5,
          //       ),
          //   textAlign: TextAlign.center,
          // ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                context,
                icon: Icons.business,
                label: 'LinkedIn',
                onPressed: () => _launchURL(
                    'https://www.linkedin.com/in/aryan-chachra-519927232'),
              ),
              const SizedBox(width: 20),
              _buildSocialButton(
                context,
                icon: Icons.code,
                label: 'GitHub',
                onPressed: () =>
                    _launchURL('https://github.com/AryanChachra/SkyOpsHub'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF21476F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2A78C8).withOpacity(0.45),
              ),
            ),
            child: Icon(
              icon,
              color: Colors.lightBlue.shade300,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.72),
              ),
        ),
      ],
    );
  }
}
