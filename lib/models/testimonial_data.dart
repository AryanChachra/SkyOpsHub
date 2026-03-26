/// Data model for testimonial content
/// Contains quote, attribution, and operational context
class TestimonialData {
  final String quote;
  final String name;
  final String role;
  final String airlineType;
  final String context;

  const TestimonialData({
    required this.quote,
    required this.name,
    required this.role,
    required this.airlineType,
    required this.context,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestimonialData &&
          runtimeType == other.runtimeType &&
          quote == other.quote &&
          name == other.name &&
          role == other.role &&
          airlineType == other.airlineType &&
          context == other.context;

  @override
  int get hashCode =>
      quote.hashCode ^
      name.hashCode ^
      role.hashCode ^
      airlineType.hashCode ^
      context.hashCode;
}
