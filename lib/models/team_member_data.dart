import 'package:flutter/material.dart';

/// Data model for team member information
/// Used in the team and founder section
class TeamMemberData {
  final String name;
  final String role;
  final String expertise;
  final IconData icon;

  const TeamMemberData({
    required this.name,
    required this.role,
    required this.expertise,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamMemberData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          role == other.role &&
          expertise == other.expertise &&
          icon == other.icon;

  @override
  int get hashCode =>
      name.hashCode ^ role.hashCode ^ expertise.hashCode ^ icon.hashCode;
}
