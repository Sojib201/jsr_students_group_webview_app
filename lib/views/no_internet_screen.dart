import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app.dart';
import '../app/app_theme.dart';
import '../controllers/connectivity_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityController>();

    // Auto-navigate when internet comes back
    ever(connectivity.isConnected, (connected) {
      if (connected) {
        Get.offNamed(AppRoutes.webview);
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B4B), Color(0xFF1A237E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with circle bg
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 60,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'No internet connection!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'To view JSR Students Group\nAn internet connection is required.\nPlease turn on WiFi or Mobile Data.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 48),

            ElevatedButton.icon(
              onPressed: () {
                final c = Get.find<ConnectivityController>();
                if (c.isConnected.value) {
                  Get.offNamed(AppRoutes.webview);
                } else {
                  Get.snackbar(
                    'No connection',
                    'Internet still unavailable.',
                    backgroundColor: Colors.red.shade700,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Try again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Auto detect text
            Obx(() => AnimatedOpacity(
                  opacity: connectivity.isConnected.value ? 1 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    connectivity.isConnected.value
                        ? '✅ Connection found...'
                        : '⏳ Waiting for connection...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
