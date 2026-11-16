
import 'package:flutter/material.dart';

class PortalLoading extends StatelessWidget {
  const PortalLoading({
    super.key,
    required this.progress,
  });

  final int progress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0B0E14),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 38,
              height: 38,
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Loading GYM Pro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                value: progress > 0
                    ? progress / 100
                    : null,
                minHeight: 3,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
