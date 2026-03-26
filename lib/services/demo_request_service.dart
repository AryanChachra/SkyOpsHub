import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config/redesign_config.dart';
import '../models/demo_request_submission.dart';

class DemoRequestService {
  const DemoRequestService();

  bool get isConfigured =>
      RedesignConfig.demoRequestWebhookUrl.trim().isNotEmpty;

  Future<DemoRequestSubmissionResult> submit(
    DemoRequestSubmission submission,
  ) async {
    final endpoint = RedesignConfig.demoRequestWebhookUrl.trim();
    if (endpoint.isEmpty) {
      return const DemoRequestSubmissionResult(
        isSuccess: false,
        message:
            'Submission backend is not configured yet. Add the deployed webhook URL in RedesignConfig.demoRequestWebhookUrl.',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        body: submission.toFormBody(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic> && decoded['ok'] == false) {
            return DemoRequestSubmissionResult(
              isSuccess: false,
              message: decoded['message'] as String?,
            );
          }
        } catch (_) {
          // Non-JSON response is treated as success for simple webhooks.
        }

        return const DemoRequestSubmissionResult(isSuccess: true);
      }

      return DemoRequestSubmissionResult(
        isSuccess: false,
        message:
            'Submission failed with status ${response.statusCode}. Please try again.',
      );
    } catch (_) {
      return const DemoRequestSubmissionResult(
        isSuccess: false,
        message:
            'We could not submit the form right now. Please try again in a moment.',
      );
    }
  }
}

class DemoRequestSubmissionResult {
  final bool isSuccess;
  final String? message;

  const DemoRequestSubmissionResult({
    required this.isSuccess,
    this.message,
  });
}
