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

  /// Smooth scroll to a specific section
  void scrollToSection(String sectionId) {
    GlobalKey? targetKey;
    
    switch (sectionId) {
      case 'hero':
        targetKey = _heroKey;
        break;
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'features':
        targetKey = _featuresKey;
        break;
      case 'value-proposition':
        targetKey = _valuePropositionKey;
        break;
      case 'product-links':
        targetKey = _productLinksKey;
        break;
      case 'open-source':
        targetKey = _openSourceKey;
        break;
      case 'tech-stack':
        targetKey = _techStackKey;
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
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
            backgroundColor: Colors.white.withOpacity(0.95),
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
            flexibleSpace: ResponsiveNavigation(
              onNavigate: scrollToSection,
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
              
              // Open Source Section
              Container(
                key: _openSourceKey,
                child: const OpenSourceSection(),
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