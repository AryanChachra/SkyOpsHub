import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/redesign_config.dart';
import '../../pages/demo_request_page.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../providers/theme_provider.dart';

/// Responsive navigation component that adapts to different screen sizes
/// Desktop: Horizontal navigation bar
/// Mobile: Hamburger menu with drawer
class ResponsiveNavigation extends StatefulWidget {
  final Function(String) onNavigate;
  final String currentSectionId;

  const ResponsiveNavigation({
    super.key,
    required this.onNavigate,
    required this.currentSectionId,
  });

  @override
  State<ResponsiveNavigation> createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  bool _isDrawerOpen = false;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(id: 'metrics', label: 'Results'),
    NavigationItem(id: 'case-studies', label: 'Case Studies'),
    NavigationItem(id: 'tech-credibility', label: 'Platform'),
    NavigationItem(id: 'team', label: 'Team'),
    if (RedesignConfig.showTestimonialsSection)
      NavigationItem(id: 'testimonials', label: 'Testimonials'),
    NavigationItem(id: 'contact', label: 'Contact'),
  ];

  void _handleNavigation(String sectionId) {
    print('Navigation clicked: $sectionId'); // Debug
    widget.onNavigate(sectionId);
    if (_isDrawerOpen) {
      setState(() {
        _isDrawerOpen = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: _buildMobileNavigation(),
      desktop: _buildDesktopNavigation(),
    );
  }

  bool get _showRequestDemoButton =>
      widget.currentSectionId != 'hero' && widget.currentSectionId != 'contact';

  Widget _buildDesktopNavigation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0) {
          return Container(
            height: 80,
            width: 100,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(
            horizontal:
                ResponsiveBreakpoints.getSafePadding(context).horizontal,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Logo and brand name
              _buildLogo(),

              const Spacer(),

              // Navigation items - only show on larger screens
              if (constraints.maxWidth > 900) ...[
                Row(
                  children: _navigationItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _buildNavItem(item),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
              ],

              // Theme toggle button
              _buildThemeToggle(),
              AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.18, 0),
                      end: Offset.zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: _showRequestDemoButton
                      ? Padding(
                          key: const ValueKey('request-demo-cta'),
                          padding: const EdgeInsets.only(left: 12),
                          child: ElevatedButton(
                            onPressed: () => DemoRequestPage.open(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Request a Demo'),
                          ),
                        )
                      : const SizedBox(
                          key: ValueKey('request-demo-cta-hidden'),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileNavigation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 70,
          padding: EdgeInsets.symmetric(
            horizontal:
                ResponsiveBreakpoints.getSafePadding(context).horizontal,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Logo
              _buildLogo(compact: true),

              const Spacer(),

              // Theme toggle button
              _buildThemeToggle(),

              const SizedBox(width: 8),

              // Hamburger menu button
              Semantics(
                label: 'Open navigation menu',
                button: true,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isDrawerOpen = true;
                    });
                    _showMobileMenu();
                  },
                  icon: const Icon(Icons.menu),
                  tooltip: 'Open navigation menu',
                  iconSize: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogo({bool compact = false}) {
    return Semantics(
      label: 'SkyOpsHub - Navigate to home',
      button: true,
      child: GestureDetector(
        onTap: () => widget.onNavigate('hero'),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: compact ? 180 : 240,
          ),
          child: Image.asset(
            'assets/images/SkyOpsHub-horizontal-wbg.png',
            height: compact ? 50 : 70,
            fit: BoxFit.contain,
            semanticLabel: 'SkyOpsHub logo',
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item) {
    return Semantics(
      label: 'Navigate to ${item.label} section',
      button: true,
      child: TextButton(
        onPressed: () => _handleNavigation(item.id),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          item.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Semantics(
          label: 'Toggle theme: currently ${themeProvider.themeModeName}',
          button: true,
          child: IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(themeProvider.themeIcon),
            tooltip: 'Theme: ${themeProvider.themeModeName}',
            iconSize: 24,
          ),
        );
      },
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMobileMenuSheet(),
    );
  }

  Widget _buildMobileMenuSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildLogo(),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isDrawerOpen = false;
                    });
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  tooltip: 'Close navigation menu',
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                ..._navigationItems.map((item) {
                  return Semantics(
                    label: 'Navigate to ${item.label} section',
                    button: true,
                    child: ListTile(
                      title: Text(
                        item.label,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.color,
                                ),
                      ),
                      onTap: () => _handleNavigation(item.id),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      minVerticalPadding: 12,
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => DemoRequestPage.open(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Request a Demo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final String id;
  final String label;

  NavigationItem({
    required this.id,
    required this.label,
  });
}
