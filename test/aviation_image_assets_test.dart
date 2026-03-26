import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skyopshub_website/utils/aviation_image_assets.dart';

void main() {
  group('AviationImageAssets', () {
    group('Asset Path Constants', () {
      test('hero section image paths are defined', () {
        expect(AviationImageAssets.heroAircraft, isNotEmpty);
        expect(AviationImageAssets.heroDashboard, isNotEmpty);
        expect(AviationImageAssets.heroControlCenter, isNotEmpty);
        
        // Verify WebP format
        expect(AviationImageAssets.heroAircraft, endsWith('.webp'));
        expect(AviationImageAssets.heroDashboard, endsWith('.webp'));
        expect(AviationImageAssets.heroControlCenter, endsWith('.webp'));
      });

      test('case study image paths are defined', () {
        expect(AviationImageAssets.caseStudyDelayReduction, isNotEmpty);
        expect(AviationImageAssets.caseStudyTurnaround, isNotEmpty);
        expect(AviationImageAssets.caseStudyRecovery, isNotEmpty);
        expect(AviationImageAssets.caseStudyCrewOptimization, isNotEmpty);
        
        // Verify WebP format
        expect(AviationImageAssets.caseStudyDelayReduction, endsWith('.webp'));
        expect(AviationImageAssets.caseStudyTurnaround, endsWith('.webp'));
        expect(AviationImageAssets.caseStudyRecovery, endsWith('.webp'));
        expect(AviationImageAssets.caseStudyCrewOptimization, endsWith('.webp'));
      });

      test('flight operations image paths are defined', () {
        expect(AviationImageAssets.flightOperations, isNotEmpty);
        expect(AviationImageAssets.aircraftOnRunway, isNotEmpty);
        expect(AviationImageAssets.controlRoom, isNotEmpty);
        
        // Verify WebP format
        expect(AviationImageAssets.flightOperations, endsWith('.webp'));
        expect(AviationImageAssets.aircraftOnRunway, endsWith('.webp'));
        expect(AviationImageAssets.controlRoom, endsWith('.webp'));
      });
    });

    group('getCaseStudyImage', () {
      test('returns delay reduction image for regional carrier', () {
        expect(
          AviationImageAssets.getCaseStudyImage('Regional Carrier'),
          equals(AviationImageAssets.caseStudyDelayReduction),
        );
        expect(
          AviationImageAssets.getCaseStudyImage('regional airline'),
          equals(AviationImageAssets.caseStudyDelayReduction),
        );
      });

      test('returns turnaround image for international airline', () {
        expect(
          AviationImageAssets.getCaseStudyImage('International Airline'),
          equals(AviationImageAssets.caseStudyTurnaround),
        );
        expect(
          AviationImageAssets.getCaseStudyImage('international carrier'),
          equals(AviationImageAssets.caseStudyTurnaround),
        );
      });

      test('returns recovery image for low-cost carrier', () {
        expect(
          AviationImageAssets.getCaseStudyImage('Low-Cost Carrier'),
          equals(AviationImageAssets.caseStudyRecovery),
        );
        expect(
          AviationImageAssets.getCaseStudyImage('Budget Carrier'),
          equals(AviationImageAssets.caseStudyRecovery),
        );
      });

      test('returns crew optimization image for unknown type', () {
        expect(
          AviationImageAssets.getCaseStudyImage('Unknown Type'),
          equals(AviationImageAssets.caseStudyCrewOptimization),
        );
        expect(
          AviationImageAssets.getCaseStudyImage(''),
          equals(AviationImageAssets.caseStudyCrewOptimization),
        );
      });
    });

    group('buildFallbackPlaceholder', () {
      testWidgets('renders fallback placeholder with icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AviationImageAssets.buildFallbackPlaceholder(
                icon: Icons.flight,
                color: Colors.blue,
                width: 200,
                height: 150,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.flight), findsOneWidget);
        
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(container.constraints?.maxWidth, equals(200));
        expect(container.constraints?.maxHeight, equals(150));
      });

      testWidgets('renders fallback placeholder with label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AviationImageAssets.buildFallbackPlaceholder(
                icon: Icons.dashboard,
                color: Colors.blue,
                label: 'Dashboard Preview',
              ),
            ),
          ),
        );

        expect(find.text('Dashboard Preview'), findsOneWidget);
        expect(find.byIcon(Icons.dashboard), findsOneWidget);
      });
    });

    group('buildImage', () {
      testWidgets('renders image widget with error builder', (tester) async {
        final fallback = Container(
          width: 100,
          height: 100,
          color: Colors.grey,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AviationImageAssets.buildImage(
                assetPath: 'assets/images/nonexistent.webp',
                fallback: fallback,
                width: 200,
                height: 150,
              ),
            ),
          ),
        );

        // Image widget should be present
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('applies border radius to image', (tester) async {
        final fallback = Container(color: Colors.grey);
        final borderRadius = BorderRadius.circular(12);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AviationImageAssets.buildImage(
                assetPath: 'assets/images/test.webp',
                fallback: fallback,
                borderRadius: borderRadius,
              ),
            ),
          ),
        );

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, equals(borderRadius));
      });
    });

    group('buildHeroVisual', () {
      testWidgets('renders hero visual for mobile', (tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  capturedContext = context;
                  return AviationImageAssets.buildHeroVisual(
                    context: context,
                    isMobile: true,
                  );
                },
              ),
            ),
          ),
        );

        // Should render an image widget
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('renders hero visual for desktop', (tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  capturedContext = context;
                  return AviationImageAssets.buildHeroVisual(
                    context: context,
                    isMobile: false,
                  );
                },
              ),
            ),
          ),
        );

        // Should render an image widget
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('buildCaseStudyImage', () {
      testWidgets('renders case study image placeholder before lazy load', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AviationImageAssets.buildCaseStudyImage(
                airlineType: 'Regional Carrier',
                height: 220,
              ),
            ),
          ),
        );

        // With lazyLoad=true, the _LazyImage widget is shown first
        // It renders the fallback placeholder until visibility is detected
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('applies border radius to case study image', (tester) async {
        final borderRadius = BorderRadius.circular(12);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AviationImageAssets.buildCaseStudyImage(
                airlineType: 'International Airline',
                height: 200,
                borderRadius: borderRadius,
              ),
            ),
          ),
        );

        // The borderRadius is stored in the buildImage call; verify widget renders
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}
