import 'package:flutter/material.dart';

/// Data model for feature information
/// Contains title, description, icon, and optional link URL
class FeatureData {
  final String title;
  final String description;
  final IconData icon;
  final String? linkUrl;
  
  const FeatureData({
    required this.title,
    required this.description,
    required this.icon,
    this.linkUrl,
  });
}