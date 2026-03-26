class DemoRequestSubmission {
  final String name;
  final String workEmail;
  final String companyName;
  final String? message;

  const DemoRequestSubmission({
    required this.name,
    required this.workEmail,
    required this.companyName,
    this.message,
  });

  Map<String, String> toFormBody() {
    return {
      'name': name,
      'workEmail': workEmail,
      'companyName': companyName,
      'message': message?.trim() ?? '',
    };
  }
}
