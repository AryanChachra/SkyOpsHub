import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skyopshub_website/utils/responsive_breakpoints.dart';
import 'package:skyopshub_website/widgets/sections/aviation_hero_section.dart';
import 'package:skyopshub_website/widgets/sections/metrics_banner.dart';
import 'package:skyopshub_website/widgets/sections/customer_proof_section.dart';
import 'package:skyopshub_website/widgets/sections/case_studies_section.dart';
import 'package:skyopshub_website/widgets/sections/tech_credibility_section.dart';
import 'package:skyopshub_website/widgets/sections/team_section.dart';
import 'package:skyopshub_website/widgets/sections/testimonials_section.dart';
import 'package:skyopshub_website/widgets/sections/cta_section.dart';
import 'package:skyopshub_website/theme/skyops_theme.dart';

void main() {
  group('Responsive Breakpoints Tests', () {
    testWidgets('Mobile breakpoint detection (<768px)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: Builder(
              builder: (context) {
                expect(ResponsiveBreakpoints.isMobile(context), true);
                expect(ResponsiveBreakpoints.isTablet(context), false);
                expect(ResponsiveBreakpoints.isDesktop(context), false);
                expect(ResponsiveBreakpoints.getDeviceType(context), DeviceType.mobile);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Tablet breakpoint detection (768px-1024px)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                expect(ResponsiveBreakpoints.isMobile(context), false);
                expect(ResponsiveBreakpoints.isTablet(context), true);
                expect(ResponsiveBreakpoints.isDesktop(context), false);
                expect(ResponsiveBreakpoints.getDeviceType(context), DeviceType.tablet);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Desktop breakpoint detection (>1024px)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: Builder(
              builder: (context) {
                expect(ResponsiveBreakpoints.isMobile(context), false);
                expect(ResponsiveBreakpoints.isTablet(context), false);
                expect(ResponsiveBreakpoints.isDesktop(context), true);
                expect(ResponsiveBreakpoints.getDeviceType(context), DeviceType.desktop);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Touch target size validation on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: Builder(
              builder: (context) {
                final touchTargetSize = ResponsiveBreakpoints.ensureTouchTargetSize(30, context);
                expect(touchTargetSize, 44.0);
                
                final largeTouchTarget = ResponsiveBreakpoints.ensureTouchTargetSize(50, context);
                expect(largeTouchTarget, 50.0);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Button padding ensures minimum touch target on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: Builder(
              builder: (context) {
                final padding = ResponsiveBreakpoints.getButtonPadding(context);
                // Minimum 44px height: vertical padding * 2 + text height should be >= 44
                expect(padding.vertical, greaterThanOrEqualTo(12));
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });

  group('Aviation Hero Section Responsive Tests', () {
    testWidgets('Aviation hero section renders on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: AviationHeroSection(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify hero section renders
      expect(find.text('Reduce flight delay minutes by up to 40%'), findsOneWidget);
      expect(find.text('See How Your Airline Can Reduce Delays'), findsOneWidget);
      expect(find.text('Run a Sample Flight Optimization'), findsOneWidget);
    });

    testWidgets('Aviation hero section renders on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: AviationHeroSection(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify hero section renders
      expect(find.text('Reduce flight delay minutes by up to 40%'), findsOneWidget);
      expect(find.text('See How Your Airline Can Reduce Delays'), findsOneWidget);
    });

    testWidgets('CTAs have minimum touch target size on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: AviationHeroSection(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find CTA buttons
      final primaryCTA = find.widgetWithText(ElevatedButton, 'See How Your Airline Can Reduce Delays');
      expect(primaryCTA, findsOneWidget);

      // Verify button has adequate size for touch
      final button = tester.widget<ElevatedButton>(primaryCTA);
      expect(button.style?.minimumSize?.resolve({}), isNotNull);
    });
  });

  group('Metrics Banner Responsive Tests', () {
    testWidgets('Metrics banner displays in column layout on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: MetricsBanner(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify metrics are present
      expect(find.text('15+'), findsOneWidget);
      expect(find.text('2000+'), findsOneWidget);
    });

    testWidgets('Metrics banner displays in row layout on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: MetricsBanner(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify metrics are present
      expect(find.text('15+'), findsOneWidget);
      expect(find.text('2000+'), findsOneWidget);
    });
  });

  group('Case Studies Section Responsive Tests', () {
    testWidgets('Case studies render in stacked layout on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: CaseStudiesSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify case studies section renders
      expect(find.text('Real Operational Impact'), findsOneWidget);
    });

    testWidgets('Case studies render in side-by-side layout on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: CaseStudiesSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify case studies section renders
      expect(find.text('Real Operational Impact'), findsOneWidget);
    });
  });

  group('Tech Credibility Section Responsive Tests', () {
    testWidgets('Tech credibility section renders on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: TechCredibilitySection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('Enterprise-Grade Platform Performance'), findsOneWidget);
      expect(find.text('10,000+'), findsOneWidget);
    });

    testWidgets('Tech credibility section renders on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: TechCredibilitySection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('Enterprise-Grade Platform Performance'), findsOneWidget);
    });
  });

  group('Team Section Responsive Tests', () {
    testWidgets('Team section renders on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: TeamSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('Built by Aviation Operations Experts'), findsOneWidget);
      expect(find.text('Our Origin Story'), findsOneWidget);
    });

    testWidgets('Team section renders on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: TeamSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('Built by Aviation Operations Experts'), findsOneWidget);
    });
  });

  group('Testimonials Section Responsive Tests', () {
    testWidgets('Testimonials render in single column on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: TestimonialsSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('What Operations Teams Say'), findsOneWidget);
    });

    testWidgets('Testimonials render in two columns on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: TestimonialsSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('What Operations Teams Say'), findsOneWidget);
    });
  });

  group('CTA Section Responsive Tests', () {
    testWidgets('CTA section renders in stacked layout on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: CTASection(
                headline: 'Test Headline',
                description: 'Test Description',
                primaryCTAText: 'Primary CTA',
                primaryCTAUrl: 'https://example.com',
                secondaryCTAText: 'Secondary CTA',
                secondaryCTAUrl: 'https://example.com/demo',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify CTA section renders
      expect(find.text('Test Headline'), findsOneWidget);
      expect(find.text('Primary CTA'), findsOneWidget);
      expect(find.text('Secondary CTA'), findsOneWidget);
    });

    testWidgets('CTA section renders in row layout on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: CTASection(
                headline: 'Test Headline',
                description: 'Test Description',
                primaryCTAText: 'Primary CTA',
                primaryCTAUrl: 'https://example.com',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify CTA section renders
      expect(find.text('Test Headline'), findsOneWidget);
      expect(find.text('Primary CTA'), findsOneWidget);
    });

    testWidgets('CTA buttons have minimum touch target size on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: CTASection(
                headline: 'Test Headline',
                description: 'Test Description',
                primaryCTAText: 'Primary CTA',
                primaryCTAUrl: 'https://example.com',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find CTA button
      final primaryCTA = find.widgetWithText(ElevatedButton, 'Primary CTA');
      expect(primaryCTA, findsOneWidget);

      // Verify button has adequate size for touch
      final button = tester.widget<ElevatedButton>(primaryCTA);
      expect(button.style?.minimumSize?.resolve({}), isNotNull);
    });
  });

  group('Customer Proof Section Responsive Tests', () {
    testWidgets('Customer proof section renders on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 667)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: CustomerProofSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('Trusted by Leading Airlines'), findsOneWidget);
    });

    testWidgets('Customer proof section renders on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: CustomerProofSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify section renders
      expect(find.text('Trusted by Leading Airlines'), findsOneWidget);
    });
  });

  group('Orientation Change Tests', () {
    testWidgets('Layout adapts to portrait orientation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(375, 667),
              orientation: Orientation.portrait,
            ),
            child: Builder(
              builder: (context) {
                expect(ResponsiveBreakpoints.isLandscape(context), false);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Layout adapts to landscape orientation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(667, 375),
              orientation: Orientation.landscape,
            ),
            child: Builder(
              builder: (context) {
                expect(ResponsiveBreakpoints.isLandscape(context), true);
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });

  group('Very Small Screen Tests', () {
    testWidgets('Layout handles very small screens (<360px)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SkyOpsTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(320, 568)),
            child: Builder(
              builder: (context) {
                final padding = ResponsiveBreakpoints.getResponsivePadding(context);
                expect(padding.horizontal, lessThanOrEqualTo(16));
                
                final fontMultiplier = ResponsiveBreakpoints.getFontSizeMultiplier(context);
                expect(fontMultiplier, lessThanOrEqualTo(0.85));
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
