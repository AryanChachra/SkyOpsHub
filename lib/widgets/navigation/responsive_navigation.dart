import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../providers/theme_provider.dart';

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
    NavigationItem(id: 'tech-stack', label: 'Technology'),
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
            horizontal: ResponsiveBreakpoints.getSafePadding(context).horizontal,
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
              
              const SizedBox(width: 12),
              
              // CTA Button
              ElevatedButton(
                onPressed: () => _handleNavigation('contact'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Get Started'),
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
            horizontal: ResponsiveBreakpoints.getSafePadding(context).horizontal,
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
              IconButton(
                onPressed: () {
                  setState(() {
                    _isDrawerOpen = true;
                  });
                  _showMobileMenu();
                },
                icon: const Icon(Icons.menu),
                iconSize: 24,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogo({bool compact = false}) {
    return GestureDetector(
      onTap: () => widget.onNavigate('hero'),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: compact ? 180 : 240,
        ),
        child: Image.asset(
          'assets/images/SkyOpsHub-horizontal-wbg.png',
          height: compact ? 50 : 70,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item) {
    return TextButton(
      onPressed: () => _handleNavigation(item.id),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
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

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          onPressed: () => themeProvider.toggleTheme(),
          icon: Icon(themeProvider.themeIcon),
          tooltip: 'Theme: ${themeProvider.themeModeName}',
          iconSize: 24,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
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