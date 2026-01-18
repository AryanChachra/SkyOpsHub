import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/skyops_theme.dart';
import 'widgets/main_layout.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SkyOpsHubWebsite(),
    ),
  );
}

class SkyOpsHubWebsite extends StatelessWidget {
  const SkyOpsHubWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'SkyOpsHub - AI-Driven Intelligence for Smarter Airline Operations',
          theme: SkyOpsTheme.lightTheme,
          darkTheme: SkyOpsTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MainLayout(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}


