
import 'package:flutter/material.dart';

class PortalErrorView extends StatelessWidget {
  const PortalErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon = Icons.cloud_off_rounded,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0B0E14),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 60,
                color: const Color(0xFF21D4F5),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFADB8CA),
                  height: 1.5,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 26),

              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
