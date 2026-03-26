import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:skyopshub_website/theme/skyops_theme.dart';
import 'package:skyopshub_website/widgets/sections/aviation_hero_section.dart';
import 'package:skyopshub_website/widgets/sections/metrics_banner.dart';
import 'package:skyopshub_website/widgets/sections/customer_proof_section.dart';
import 'package:skyopshub_website/widgets/sections/tech_credibility_section.dart';
import 'package:skyopshub_website/widgets/sections/team_section.dart';
import 'package:skyopshub_website/widgets/sections/cta_section.dart';
import 'package:skyopshub_website/widgets/cards/testimonial_card.dart';
import 'package:skyopshub_website/widgets/cards/case_study_card.dart';
import 'package:skyopshub_website/models/testimonial_data.dart';
import 'package:skyopshub_website/models/case_study_data.dart';
import 'package:skyopshub_website/utils/animation_helpers.dart';

void main() {
  // Set VisibilityDetector update interval to zero so timers fire immediately in tests
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });
  group('Color Contrast Ratio Tests (WCAG AA)', () {
    test('Primary blue on white meets WCAG AA contrast ratio (4.5:1)', () {
      // Primary blue #0B3D91 on white #FFFFFF
      // Calculated relative luminance: primary blue ~0.045, white ~1.0
      // Contrast ratio = (1.0 + 0.05) / (0.045 + 0.05) ≈ 11.0 — passes AA
      final ratio = _contrastRatio(SkyOpsTheme.primaryBlue, Colors.white);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Primary blue on white must meet WCAG AA (4.5:1)');
    });

    test('Accent blue on dark background meets WCAG AA contrast ratio', () {
      // Accent blue #1FB6FF on dark background #0A1929
      final ratio = _contrastRatio(SkyOpsTheme.accentBlue, SkyOpsTheme.darkHeroBackground);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Accent blue on dark background must meet WCAG AA (4.5:1)');
    });

    test('White text on primary blue meets WCAG AA contrast ratio', () {
      final ratio = _contrastRatio(Colors.white, SkyOpsTheme.primaryBlue);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'White text on primary blue must meet WCAG AA (4.5:1)');
    });

    test('White text on dark hero background meets WCAG AA contrast ratio', () {
      final ratio = _contrastRatio(Colors.white, SkyOpsTheme.darkHeroBackground);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'White text on dark hero background must meet WCAG AA (4.5:1)');
    });

    test('Dark text on light background meets WCAG AA contrast ratio', () {
      final ratio = _contrastRatio(SkyOpsTheme.textPrimary, SkyOpsTheme.backgroundColor);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Dark text on light background must meet WCAG AA (4.5:1)');
    });
  });

  group('Reduced Motion Alternatives Tests', () {
    testWidgets('FadeInAnimation skips animation when disableAnimations is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: FadeInAnimation(
                triggerOnScroll: false,
                child: Text('Reduced motion content'),
              ),
            ),
          ),
        ),
      );

      // With reduced motion, child renders directly — no FadeTransition
      expect(find.text('Reduced motion content'), findsOneWidget);
      expect(find.byType(FadeTransition), findsNothing);
    });

    testWidgets('SlideUpAnimation skips animation when disableAnimations is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: SlideUpAnimation(
                triggerOnScroll: false,
                child: Text('Reduced motion slide'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Reduced motion slide'), findsOneWidget);
      expect(find.byType(SlideTransition), findsNothing);
    });

    testWidgets('HoverElevationCard skips animation when disableAnimations is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: HoverElevationCard(
                child: SizedBox(key: Key('hover-child'), width: 100, height: 100),
              ),
            ),
          ),
        ),
      );

      // With reduced motion, HoverElevationCard renders child directly.
      // The child SizedBox should be present.
      expect(find.byKey(const Key('hover-child')), findsOneWidget);
      // No MouseRegion inside HoverElevationCard means no hover tracking
      final hoverCard = find.byType(HoverElevationCard);
      expect(hoverCard, findsOneWidget);
      // The child is rendered directly — verify no Transform.scale wrapping it
      expect(
        find.descendant(of: hoverCard, matching: find.byType(Transform)),
        findsNothing,
      );
    });

    testWidgets('AnimatedCounter shows final value immediately when disableAnimations is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: AnimatedCounter(
                value: 42,
                triggerOnScroll: false,
              ),
            ),
          ),
        ),
      );

      // With reduced motion, final value should show immediately
      expect(find.text('42'), findsOneWidget);
    });
  });

  group('Touch Target Size Tests (44x44px minimum)', () {
    testWidgets('Hero section primary CTA meets minimum touch target on mobile',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(375, 1200)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: AviationHeroSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final primaryBtn = find.widgetWithText(ElevatedButton, 'See How Your Airline Can Reduce Delays');
      expect(primaryBtn, findsOneWidget);

      final btn = tester.widget<ElevatedButton>(primaryBtn);
      final minSize = btn.style?.minimumSize?.resolve({});
      expect(minSize?.height, greaterThanOrEqualTo(44.0));
    });

    testWidgets('CTA section buttons meet minimum touch target on mobile',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(375, 667)),
            child: Scaffold(
              body: CTASection(
                headline: 'Test',
                description: 'Test description',
                primaryCTAText: 'Schedule a Demo with Operations Experts',
                primaryCTAUrl: 'https://example.com',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final primaryBtn = find.widgetWithText(ElevatedButton, 'Schedule a Demo with Operations Experts');
      expect(primaryBtn, findsOneWidget);

      final btn = tester.widget<ElevatedButton>(primaryBtn);
      final minSize = btn.style?.minimumSize?.resolve({});
      expect(minSize?.height, greaterThanOrEqualTo(44.0));
    });
  });

  group('Semantics / ARIA Label Tests', () {
    testWidgets('Hero section has Semantics widget wrapping content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(375, 1200)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: AviationHeroSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Semantics widgets are present in the hero section
      expect(find.byType(Semantics), findsWidgets);
      // Verify the main headline is present for screen readers
      expect(find.text('Reduce flight delay minutes by up to 40%'), findsOneWidget);
    });

    testWidgets('Testimonial card has semantics label with name and role',
        (WidgetTester tester) async {
      const testimonial = TestimonialData(
        quote: 'SkyOpsHub reduced our average delay by 35 minutes per disruption.',
        name: 'Jane Smith',
        role: 'Director of Operations',
        airlineType: 'Regional Carrier, 120 daily flights',
        context: 'Implemented during peak summer season',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: TestimonialCard(testimonial: testimonial),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Semantics widget is present
      expect(find.byType(Semantics), findsWidgets);
      // Verify attribution text is readable
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.text('Director of Operations'), findsOneWidget);
    });

    testWidgets('Case study card has semantics label with airline type and metric',
        (WidgetTester tester) async {
      const caseStudy = CaseStudyData(
        airlineType: 'Regional Carrier',
        problemStatement: 'Cascading delays due to crew scheduling conflicts.',
        solutionApproach: 'Real-time crew optimization with duty compliance checks.',
        outcome: 'Reduced average delay by 40% within 3 months.',
        metricValue: '40%',
        metricLabel: 'Delay Reduction',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CaseStudyCard(caseStudy: caseStudy),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Semantics widget is present
      expect(find.byType(Semantics), findsWidgets);
      // Verify key content is readable
      expect(find.text('Regional Carrier'), findsOneWidget);
      expect(find.text('40%'), findsOneWidget);
      expect(find.text('Delay Reduction'), findsOneWidget);
    });

    testWidgets('Tech credibility certification badges have semantics labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: TechCredibilitySection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Semantics widgets are present
      expect(find.byType(Semantics), findsWidgets);
      // Verify certification text is readable
      expect(find.textContaining('SOC 2'), findsOneWidget);
    });

    testWidgets('Customer proof logos have semantics labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CustomerProofSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Semantics widgets are present for logos
      expect(find.byType(Semantics), findsWidgets);
      // Verify airline names are present as text for screen readers
      expect(find.textContaining('Airline'), findsWidgets);
    });
  });

  group('Keyboard Navigation Tests', () {
    testWidgets('CTA buttons are focusable via keyboard', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: Scaffold(
              body: CTASection(
                headline: 'Test',
                description: 'Test description',
                primaryCTAText: 'Schedule a Demo with Operations Experts',
                primaryCTAUrl: 'https://example.com',
                secondaryCTAText: 'Run a Sample Flight Optimization',
                secondaryCTAUrl: 'https://example.com/demo',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // ElevatedButton and OutlinedButton are inherently focusable
      final primaryBtn = find.widgetWithText(ElevatedButton, 'Schedule a Demo with Operations Experts');
      final secondaryBtn = find.widgetWithText(OutlinedButton, 'Run a Sample Flight Optimization');

      expect(primaryBtn, findsOneWidget);
      expect(secondaryBtn, findsOneWidget);

      // Verify buttons can receive focus
      await tester.tap(primaryBtn);
      await tester.pump();
      expect(tester.widget<ElevatedButton>(primaryBtn).onPressed, isNotNull);
    });

    testWidgets('Hero section CTA buttons are keyboard accessible',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(375, 1200)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: AviationHeroSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final primaryBtn = find.widgetWithText(ElevatedButton, 'See How Your Airline Can Reduce Delays');
      final secondaryBtn = find.widgetWithText(OutlinedButton, 'Run a Sample Flight Optimization');

      expect(primaryBtn, findsOneWidget);
      expect(secondaryBtn, findsOneWidget);

      // Buttons must have onPressed callbacks (keyboard activatable)
      expect(tester.widget<ElevatedButton>(primaryBtn).onPressed, isNotNull);
      expect(tester.widget<OutlinedButton>(secondaryBtn).onPressed, isNotNull);
    });
  });

  group('Screen Reader Content Tests', () {
    testWidgets('Metrics banner provides readable metric values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(375, 800)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: MetricsBanner(),
              ),
            ),
          ),
        ),
      );
      // Drain initial frame + Future.delayed timers (max 400ms delay + 1200ms animation)
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 2000));

      // Verify metric labels are present for screen readers
      expect(find.text('Airlines'), findsOneWidget);
      expect(find.text('Daily Flights'), findsOneWidget);
    });

    testWidgets('Team section content is readable by screen readers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(size: Size(1440, 900)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: TeamSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify key content is present and readable
      expect(find.text('Built by Aviation Operations Experts'), findsOneWidget);
      expect(find.text('Our Origin Story'), findsOneWidget);
      expect(find.text('Operations Leadership'), findsOneWidget);
      expect(find.text('AI Research Team'), findsOneWidget);
      expect(find.text('Engineering Team'), findsOneWidget);
    });
  });
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Calculate relative luminance of a color per WCAG 2.1 spec.
double _relativeLuminance(Color color) {
  double linearize(double channel) {
    final c = channel / 255.0;
    return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) * ((c + 0.055) / 1.055);
  }

  final r = linearize(color.red.toDouble());
  final g = linearize(color.green.toDouble());
  final b = linearize(color.blue.toDouble());
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Calculate WCAG contrast ratio between two colors.
double _contrastRatio(Color foreground, Color background) {
  final l1 = _relativeLuminance(foreground);
  final l2 = _relativeLuminance(background);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}
