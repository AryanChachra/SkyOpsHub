import 'package:flutter/material.dart';
import '../widgets/navigation/responsive_navigation.dart';
import '../widgets/sections/aviation_hero_section.dart';
import '../widgets/sections/metrics_banner.dart';
import '../widgets/sections/customer_proof_section.dart';
import '../widgets/sections/case_studies_section.dart';
import '../widgets/sections/tech_credibility_section.dart';
import '../widgets/sections/team_section.dart';
import '../widgets/sections/testimonials_section.dart';
import '../widgets/sections/cta_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/footer/footer_widget.dart';
import '../config/redesign_config.dart';
import '../pages/demo_request_page.dart';

/// Main layout widget that contains the entire website structure
/// Uses GlobalKeys for accurate section-based smooth scrolling
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ScrollController _scrollController = ScrollController();
  Orientation? _previousOrientation;
  String _activeSectionId = 'hero';
  bool _showScrollToTopButton = false;

  // GlobalKeys for accurate section scroll targeting
  final _heroKey = GlobalKey();
  final _metricsKey = GlobalKey();
  final _customerProofKey = GlobalKey();
  final _caseStudiesKey = GlobalKey();
  final _techCredibilityKey = GlobalKey();
  final _teamKey = GlobalKey();
  final _testimonialsKey = GlobalKey();
  final _contactKey = GlobalKey();

  // Lazy loading state: track which below-the-fold sections are loaded
  bool _loadBelowFold = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldLoadBelowFold =
        !_loadBelowFold && _scrollController.offset > 200;
    final heroBoundaryOffset = _getSectionScrollOffset(_metricsKey) ?? 500.0;
    final shouldShowScrollToTop =
        _scrollController.offset > heroBoundaryOffset - 120;

    if (shouldLoadBelowFold ||
        shouldShowScrollToTop != _showScrollToTopButton) {
      setState(() {
        if (shouldLoadBelowFold) {
          _loadBelowFold = true;
        }
        _showScrollToTopButton = shouldShowScrollToTop;
      });
    }

    _updateActiveSection();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Handle orientation changes smoothly
    final currentOrientation = MediaQuery.of(context).orientation;
    if (_previousOrientation != null &&
        _previousOrientation != currentOrientation) {
      setState(() {});
    }
    _previousOrientation = currentOrientation;
  }

  /// Smooth scroll to a specific section using GlobalKey for accurate positioning
  void scrollToSection(String sectionId) {
    if (!_scrollController.hasClients) return;

    GlobalKey? targetKey;
    switch (sectionId) {
      case 'hero':
        targetKey = _heroKey;
        break;
      case 'metrics':
        targetKey = _metricsKey;
        break;
      case 'customer-proof':
        if (RedesignConfig.showCustomerProofSection) {
          targetKey = _customerProofKey;
        }
        break;
      case 'case-studies':
        targetKey = _caseStudiesKey;
        break;
      case 'tech-credibility':
        targetKey = _techCredibilityKey;
        break;
      case 'team':
        targetKey = _teamKey;
        break;
      case 'testimonials':
        if (RedesignConfig.showTestimonialsSection) {
          targetKey = _testimonialsKey;
        }
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey == null) return;

    // If below-fold content isn't loaded yet, load it first then scroll
    if (!_loadBelowFold && sectionId != 'hero' && sectionId != 'metrics') {
      setState(() {
        _loadBelowFold = true;
      });
      // Wait for the layout to complete before scrolling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToKey(targetKey!);
      });
      return;
    }

    _scrollToKey(targetKey);
  }

  void _updateActiveSection() {
    final markerOffset =
        _scrollController.hasClients ? _scrollController.offset + 140 : 140.0;

    final sectionEntries = <MapEntry<String, GlobalKey>>[
      MapEntry('hero', _heroKey),
      MapEntry('metrics', _metricsKey),
      if (RedesignConfig.showCustomerProofSection)
        MapEntry('customer-proof', _customerProofKey),
      MapEntry('case-studies', _caseStudiesKey),
      MapEntry('tech-credibility', _techCredibilityKey),
      MapEntry('team', _teamKey),
      if (RedesignConfig.showTestimonialsSection)
        MapEntry('testimonials', _testimonialsKey),
      MapEntry('contact', _contactKey),
    ];

    String nextSection = _activeSectionId;
    double bestOffset = -1;

    for (final entry in sectionEntries) {
      final offset = _getSectionScrollOffset(entry.value);
      if (offset == null) continue;
      if (offset <= markerOffset && offset >= bestOffset) {
        bestOffset = offset;
        nextSection = entry.key;
      }
    }

    if (nextSection != _activeSectionId && mounted) {
      setState(() {
        _activeSectionId = nextSection;
      });
    }
  }

  double? _getSectionScrollOffset(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;

    final renderBox = ctx.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final position = renderBox.localToGlobal(Offset.zero);
    return _scrollController.offset + position.dy - 80;
  }

  void _scrollToKey(GlobalKey key) {
    final scrollOffset = _getSectionScrollOffset(key);
    if (scrollOffset == null) return;

    _scrollController.animateTo(
      scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showScrollToTopButton
          ? Tooltip(
              message: 'Scroll to top',
              child: FloatingActionButton.small(
                onPressed: () => scrollToSection('hero'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
            )
          : null,
      body: Column(
        children: [
          // Fixed navigation bar
          Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: ResponsiveNavigation(
              onNavigate: scrollToSection,
              currentSectionId: _activeSectionId,
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Above-the-fold: always loaded immediately
                  KeyedSubtree(
                    key: _heroKey,
                    child: AviationHeroSection(
                      onRequestDemo: () => DemoRequestPage.open(context),
                    ),
                  ),
                  KeyedSubtree(key: _metricsKey, child: const MetricsBanner()),

                  // Below-the-fold: lazy loaded after first scroll
                  if (_loadBelowFold) ...[
                    if (RedesignConfig.showCustomerProofSection)
                      KeyedSubtree(
                        key: _customerProofKey,
                        child: const CustomerProofSection(),
                      ),
                    KeyedSubtree(
                        key: _caseStudiesKey,
                        child: const CaseStudiesSection()),
                    KeyedSubtree(
                        key: _techCredibilityKey,
                        child: const TechCredibilitySection()),
                    KeyedSubtree(key: _teamKey, child: const TeamSection()),
                    if (RedesignConfig.showTestimonialsSection)
                      KeyedSubtree(
                        key: _testimonialsKey,
                        child: const TestimonialsSection(),
                      ),
                    CTASection(
                      headline: 'Ready to explore smarter airline scheduling?',
                      description:
                          'See how SkyOps Hub can help improve crew scheduling, aircraft utilization, and operational efficiency.',
                      primaryCTAText: 'Request a Demo',
                      primaryCTAUrl: 'https://app.skyopshub.in/demo',
                      secondaryCTAText: 'Run a Sample Flight Optimization',
                      secondaryCTAUrl: 'https://app.skyopshub.in/optimize',
                      isDarkBackground: true,
                      onPrimaryPressed: () => scrollToSection('contact'),
                      showButtons: false,
                    ),
                    KeyedSubtree(
                        key: _contactKey, child: const ContactSection()),
                    FooterWidget(onNavigate: scrollToSection),
                  ] else ...[
                    // Placeholder to allow scrolling to trigger lazy load
                    const _BelowFoldPlaceholder(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight placeholder shown before below-the-fold content loads.
/// Provides enough height to trigger the scroll listener.
class _BelowFoldPlaceholder extends StatelessWidget {
  const _BelowFoldPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading additional content',
      child: Container(
        height: 400,
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FB6FF)),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
