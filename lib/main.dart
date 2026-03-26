import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'pages/demo_request_page.dart';
import 'theme/skyops_theme.dart';
import 'widgets/main_layout.dart';
import 'providers/theme_provider.dart';
import 'utils/performance_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure image cache for optimal web performance
  PerformanceUtils.configureImageCache();

  // Disable debug printing in release mode
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SkyOpsHubWebsite(),
    ),
  );
}

class SkyOpsHubWebsite extends StatelessWidget {
  const SkyOpsHubWebsite({super.key});

  static String _normalizeInitialRoute(String? routeName) {
    if (routeName == null || routeName.isEmpty) {
      return '/';
    }

    final uri = Uri.tryParse(routeName);
    final path = uri?.path ?? routeName;

    if (path == '/form' || path == '/form/') {
      return '/form';
    }

    return '/';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final initialRoute = _normalizeInitialRoute(
          WidgetsBinding.instance.platformDispatcher.defaultRouteName,
        );

        return MaterialApp(
          title:
              'SkyOpsHub - AI-Driven Intelligence for Smarter Airline Operations',
          theme: SkyOpsTheme.lightTheme,
          darkTheme: SkyOpsTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/form':
                return MaterialPageRoute<void>(
                  builder: (_) => const DemoRequestPage(),
                  settings: settings,
                );
              case '/':
              default:
                return MaterialPageRoute<void>(
                  builder: (_) => const MainLayout(),
                  settings: settings,
                );
            }
          },
        );
      },
    );
  }
}
