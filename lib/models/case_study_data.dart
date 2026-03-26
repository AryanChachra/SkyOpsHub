/// Data model for case study content
/// Contains problem-solution-outcome structure for case studies
class CaseStudyData {
  final String airlineType;
  final String problemStatement;
  final String solutionApproach;
  final String outcome;
  final String metricValue;
  final String metricLabel;

  const CaseStudyData({
    required this.airlineType,
    required this.problemStatement,
    required this.solutionApproach,
    required this.outcome,
    required this.metricValue,
    required this.metricLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseStudyData &&
          runtimeType == other.runtimeType &&
          airlineType == other.airlineType &&
          problemStatement == other.problemStatement &&
          solutionApproach == other.solutionApproach &&
          outcome == other.outcome &&
          metricValue == other.metricValue &&
          metricLabel == other.metricLabel;

  @override
  int get hashCode =>
      airlineType.hashCode ^
      problemStatement.hashCode ^
      solutionApproach.hashCode ^
      outcome.hashCode ^
      metricValue.hashCode ^
      metricLabel.hashCode;
}
