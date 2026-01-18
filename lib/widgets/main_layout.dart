import 'package:flutter/material.dart';
import '../widgets/navigation/responsive_navigation.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/features_section.dart';
import '../widgets/sections/value_proposition_section.dart';
import '../widgets/sections/product_links_section.dart';
import '../widgets/sections/open_source_section.dart';
import '../widgets/sections/tech_stack_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/footer/footer_widget.dart';

/// Main layout widget that contains the entire website structure
/// Uses CustomScrollView with SliverAppBar for smooth scrolling navigation
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ScrollController _scrollController = ScrollController();
  
  // Global keys for each section to enable smooth scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _valuePropositionKey = GlobalKey();
  final GlobalKey _productLinksKey = GlobalKey();
  final GlobalKey _openSourceKey = GlobalKey();
  final GlobalKey _techStackKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Smooth scroll to a specific section using scroll controller
  void scrollToSection(String sectionId) {
    print('Attempting to scroll to section: $sectionId'); // Debug
    
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
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Navigation bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: Container(
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
          ),
          
          // Main content sections
          SliverList(
            delegate: SliverChildListDelegate([
              // Hero Section
              Container(
                key: _heroKey,
                child: const HeroSection(),
              ),
              
              // About Section
              Container(
                key: _aboutKey,
                child: const AboutSection(),
              ),
              
              // Features Section
              Container(
                key: _featuresKey,
                child: const FeaturesSection(),
              ),
              
              // Value Proposition Section
              Container(
                key: _valuePropositionKey,
                child: const ValuePropositionSection(),
              ),
              
              // Product Links Section
              Container(
                key: _productLinksKey,
                child: const ProductLinksSection(),
              ),
              
              // Tech Stack Section
              Container(
                key: _techStackKey,
                child: const TechStackSection(),
              ),
              
              // Contact Section
              Container(
                key: _contactKey,
                child: const ContactSection(),
              ),
              
              // Footer
              const FooterWidget(),
            ]),
          ),
        ],
      ),
    );
  }
}