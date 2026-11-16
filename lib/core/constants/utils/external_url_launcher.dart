
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalUrlLauncher {
  ExternalUrlLauncher._();

  static Future<void> open(
    BuildContext context,
    Uri uri,
  ) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        _showError(
          context,
          'No application is available to open this link.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showError(
          context,
          'Unable to open this link.',
        );
      }
    }
  }

  static void _showError(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}
