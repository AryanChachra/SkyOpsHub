import 'package:flutter/material.dart';
import 'theme/skyops_theme.dart';
import 'widgets/main_layout.dart';

void main() {
  runApp(const SkyOpsHubWebsite());
}

class SkyOpsHubWebsite extends StatelessWidget {
  const SkyOpsHubWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyOpsHub - AI-Driven Intelligence for Smarter Airline Operations',
      theme: SkyOpsTheme.lightTheme,
      home: const MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}


