import 'package:flutter/material.dart';
import '../widgets/navigation/responsive_navigation.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/features_section.dart';
import '../widgets/sections/value_proposition_section.dart';
import '../widgets/sections/product_links_section.dart';
import '../widgets/sections/tech_stack_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/footer/footer_widget.dart';

/// Main layout widget that contains the entire website structure
/// Uses simple SingleChildScrollView for better stability
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Smooth scroll to a specific section using scroll controller
  void scrollToSection(String sectionId) {
    print('Attempting to scroll to section: $sectionId'); // Debug
    
    // Safety check for scroll controller
    if (!_scrollController.hasClients) {
      print('ScrollController has no clients, skipping scroll');
      return;
    }
    
    // Define approximate positions for each section (in pixels)
    double targetPosition = 0;
    
    switch (sectionId) {
      case 'hero':
        targetPosition = 0;
        break;
      case 'about':
        targetPosition = 700; // Approximate position after hero
        break;
      case 'features':
        targetPosition = 1600; // Approximate position after about
        break;
      case 'value-proposition':
        targetPosition = 2600; // Approximate position after features
        break;
      case 'product-links':
        targetPosition = 3600; // Approximate position after value prop
        break;
      case 'tech-stack':
        targetPosition = 4700; // Approximate position after open source
        break;
      case 'contact':
        targetPosition = 6100; // Approximate position after tech stack
        break;
    }

    // Ensure target position is within bounds
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    targetPosition = targetPosition.clamp(0.0, maxScrollExtent);

    // Scroll to the calculated position
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    
    print('Scrolling to position: $targetPosition for section: $sectionId'); // Debug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed navigation bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: ResponsiveNavigation(
              onNavigate: scrollToSection,
            ),
          ),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Hero Section
                  const HeroSection(),
                  
                  // About Section
                  const AboutSection(),
                  
                  // Features Section
                  const FeaturesSection(),
                  
                  // Value Proposition Section
                  const ValuePropositionSection(),
                  
                  // Product Links Section
                  const ProductLinksSection(),
                  
                  // Tech Stack Section
                  const TechStackSection(),
                  
                  // Contact Section
                  const ContactSection(),
                  
                  // Footer
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}