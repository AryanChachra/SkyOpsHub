import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../theme/skyops_theme.dart';

/// Responsive navigation component that adapts to different screen sizes
/// Desktop: Horizontal navigation bar
/// Mobile: Hamburger menu with drawer
class ResponsiveNavigation extends StatefulWidget {
  final Function(String) onNavigate;
  
  const ResponsiveNavigation({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ResponsiveNavigation> createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  bool _isDrawerOpen = false;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(id: 'about', label: 'About'),
    NavigationItem(id: 'features', label: 'Features'),
    NavigationItem(id: 'value-proposition', label: 'Why SkyOpsHub'),
    NavigationItem(id: 'product-links', label: 'Product'),
    NavigationItem(id: 'open-source', label: 'Open Source'),
    NavigationItem(id: 'tech-stack', label: 'Technology'),
    NavigationItem(id: 'contact', label: 'Contact'),
  ];

  void _handleNavigation(String sectionId) {
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

  Widget _buildDesktopNavigation() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          // Logo and brand name
          _buildLogo(),
          
          const Spacer(),
          
          // Navigation items
          Row(
            children: _navigationItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildNavItem(item),
              );
            }).toList(),
          ),
          
          const SizedBox(width: 24),
          
          // CTA Button
          ElevatedButton(
            onPressed: () => _handleNavigation('contact'),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavigation() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Logo
          _buildLogo(compact: true),
          
          const Spacer(),
          
          // Hamburger menu button
          IconButton(
            onPressed: () {
              setState(() {
                _isDrawerOpen = true;
              });
              _showMobileMenu();
            },
            icon: const Icon(Icons.menu),
            iconSize: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo({bool compact = false}) {
    return GestureDetector(
      onTap: () => widget.onNavigate('hero'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo image
          Image.asset(
            'assets/images/SkyOpsHub-horizontal.png',
            height: compact ? 32 : 40,
            fit: BoxFit.contain,
          ),
          if (!compact) ...[
            const SizedBox(width: 12),
            Text(
              'SkyOpsHub',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: SkyOpsTheme.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item) {
    return TextButton(
      onPressed: () => _handleNavigation(item.id),
      style: TextButton.styleFrom(
        foregroundColor: SkyOpsTheme.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
              color: Colors.grey.shade300,
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
                  return ListTile(
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => _handleNavigation(item.id),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  );
                }),
                
                const SizedBox(height: 24),
                
                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleNavigation('contact'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Get Started'),
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