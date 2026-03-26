import 'package:flutter/material.dart';

/// Data model for technical performance metrics
/// Used in the technology credibility section
class PerformanceMetricData {
  final String value;
  final String label;
  final String description;
  final IconData icon;

  const PerformanceMetricData({
    required this.value,
    required this.label,
    required this.description,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceMetricData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label &&
          description == other.description &&
          icon == other.icon;

  @override
  int get hashCode =>
      value.hashCode ^
      label.hashCode ^
      description.hashCode ^
      icon.hashCode;
}
