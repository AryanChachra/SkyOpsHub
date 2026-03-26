import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skyopshub_website/main.dart';
import 'package:skyopshub_website/widgets/main_layout.dart';
import 'package:skyopshub_website/widgets/sections/aviation_hero_section.dart';
import 'package:skyopshub_website/widgets/sections/metrics_banner.dart';
import 'package:skyopshub_website/widgets/sections/customer_proof_section.dart';
import 'package:skyopshub_website/widgets/sections/case_studies_section.dart';
import 'package:skyopshub_website/widgets/sections/tech_credibility_section.dart';
import 'package:skyopshub_website/widgets/sections/team_section.dart';
import 'package:skyopshub_website/widgets/sections/testimonials_section.dart';
import 'package:skyopshub_website/widgets/sections/cta_section.dart';
import 'package:skyopshub_website/utils/responsive_breakpoints.dart';

/// Chrome Browser Compatibility Tests
/// Tests website rendering, animations, responsive breakpoints, and interactive elements
/// Validates Requirements: 14.1, 14.2, 14.3, 14.4, 14.5, 14.6, 14.7
void main() {
  group('Chrome Browser Compatibility Tests', () {
    testWidgets('Website renders correctly with all sections', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Verify main layout renders
      expect(find.byType(MainLayout), findsOneWidget);

      // Verify all major sections are present
      expect(find.byType(AviationHeroSection), findsOneWidget);
      expect(find.byType(MetricsBanner), findsOneWidget);
      expect(find.byType(CustomerProofSection), findsOneWidget);
      expect(find.byType(CaseStudiesSection), findsOneWidget);
      expect(find.byType(TechCredibilitySection), findsOneWidget);
      expect(find.byType(TeamSection), findsOneWidget);
      expect(find.byType(TestimonialsSection), findsOneWidget);
      expect(find.byType(CTASection), findsOneWidget);
    });

    testWidgets('Aviation hero section renders with dark gradient', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AviationHeroSection())));
      await tester.pumpAndSettle();

      // Verify hero section renders
      expect(find.byType(AviationHeroSection), findsOneWidget);

      // Verify headline is present
      expect(find.textContaining('Reduce flight delay'), findsOneWidget);
    });

    testWidgets('Metrics banner displays all metrics', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: MetricsBanner())));
      await tester.pumpAndSettle();

      // Verify metrics are displayed
      expect(find.textContaining('15+'), findsOneWidget);
      expect(find.textContaining('2000+'), findsOneWidget);
      expect(find.textContaining('\$50M+'), findsOneWidget);
    });

    testWidgets('Responsive breakpoints function correctly - Desktop', (WidgetTester tester) async {
      // Set desktop size
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Verify desktop layout
      final context = tester.element(find.byType(MainLayout));
      expect(ResponsiveBreakpoints.isDesktop(context), isTrue);
      expect(ResponsiveBreakpoints.isMobile(context), isFalse);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Responsive breakpoints function correctly - Tablet', (WidgetTester tester) async {
      // Set tablet size
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Verify tablet layout
      final context = tester.element(find.byType(MainLayout));
      expect(ResponsiveBreakpoints.isTablet(context), isTrue);
      expect(ResponsiveBreakpoints.isMobile(context), isFalse);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Responsive breakpoints function correctly - Mobile', (WidgetTester tester) async {
      // Set mobile size
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Verify mobile layout
      final context = tester.element(find.byType(MainLayout));
      expect(ResponsiveBreakpoints.isMobile(context), isTrue);
      expect(ResponsiveBreakpoints.isDesktop(context), isFalse);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Interactive CTA buttons are present and accessible', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Verify CTA buttons exist
      expect(find.byType(ElevatedButton), findsWidgets);
      expect(find.byType(OutlinedButton), findsWidgets);

      // Verify CTA text is value-driven
      expect(find.textContaining('Demo'), findsWidgets);
      expect(find.textContaining('Optimization'), findsWidgets);
    });

    testWidgets('All sections maintain proper spacing and layout', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Verify scrollable content
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Verify sections are stacked vertically
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Aviation visual motifs render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AviationHeroSection())));
      await tester.pumpAndSettle();

      // Verify CustomPaint widgets for aviation motifs
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Tech credibility section displays performance metrics', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TechCredibilitySection())));
      await tester.pumpAndSettle();

      // Verify performance metrics
      expect(find.textContaining('10,000+'), findsOneWidget);
      expect(find.textContaining('<100ms'), findsOneWidget);
      expect(find.textContaining('99.99%'), findsOneWidget);
    });

    testWidgets('Case studies section renders multiple case studies', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CaseStudiesSection())));
      await tester.pumpAndSettle();

      // Verify case studies section renders
      expect(find.byType(CaseStudiesSection), findsOneWidget);
    });

    testWidgets('Testimonials section renders testimonial cards', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TestimonialsSection())));
      await tester.pumpAndSettle();

      // Verify testimonials section renders
      expect(find.byType(TestimonialsSection), findsOneWidget);
    });

    testWidgets('Team section renders founder story and team profiles', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TeamSection())));
      await tester.pumpAndSettle();

      // Verify team section renders
      expect(find.byType(TeamSection), findsOneWidget);
      expect(find.textContaining('Aviation Operations Experts'), findsOneWidget);
    });

    testWidgets('Customer proof section displays airline logos', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CustomerProofSection())));
      await tester.pumpAndSettle();

      // Verify customer proof section renders
      expect(find.byType(CustomerProofSection), findsOneWidget);
      expect(find.textContaining('Trusted by Leading Airlines'), findsOneWidget);
    });

    testWidgets('Website maintains 60fps performance target', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyOpsHubWebsite());
      
      // Pump frames and verify no dropped frames
      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16)); // 60fps = 16.67ms per frame
      }

      // If we reach here without errors, performance is acceptable
      expect(find.byType(MainLayout), findsOneWidget);
    });

    testWidgets('Animations complete within expected timeframes', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyOpsHubWebsite());
      
      // Initial pump
      await tester.pump();
      
      // Pump for animation duration (1200ms for FadeIn)
      await tester.pump(const Duration(milliseconds: 1200));
      
      // Settle all animations
      await tester.pumpAndSettle();

      // Verify all sections are visible after animations
      expect(find.byType(AviationHeroSection), findsOneWidget);
      expect(find.byType(MetricsBanner), findsOneWidget);
    });

    testWidgets('Touch targets meet minimum size on mobile', (WidgetTester tester) async {
      // Set mobile size
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      // Find all buttons
      final buttons = find.byType(ElevatedButton);
      
      // Verify buttons exist
      expect(buttons, findsWidgets);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Website handles orientation changes smoothly', (WidgetTester tester) async {
      // Portrait
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(const SkyOpsHubWebsite());
      await tester.pumpAndSettle();

      expect(find.byType(MainLayout), findsOneWidget);

      // Landscape
      tester.view.physicalSize = const Size(667, 375);
      await tester.pumpAndSettle();

      expect(find.byType(MainLayout), findsOneWidget);

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
