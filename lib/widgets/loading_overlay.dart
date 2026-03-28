import 'package:flutter/material.dart';
import '../app/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  final int progress;

  const LoadingOverlay({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar at top
        LinearProgressIndicator(
          value: progress > 0 ? progress / 100 : null,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
          minHeight: 3,
        ),
      ],
    );
  }
}
