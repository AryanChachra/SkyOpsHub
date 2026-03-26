import 'package:flutter/material.dart';

/// Data model for metrics banner display
/// Contains quantifiable achievements for the metrics banner section
class MetricData {
  final String value;
  final String label;
  final String sublabel;
  final IconData icon;

  const MetricData({
    required this.value,
    required this.label,
    required this.sublabel,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetricData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label &&
          sublabel == other.sublabel &&
          icon == other.icon;

  @override
  int get hashCode =>
      value.hashCode ^ label.hashCode ^ sublabel.hashCode ^ icon.hashCode;
}
