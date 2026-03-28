import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../app/app_theme.dart';
import '../controllers/webview_controller.dart';
import '../controllers/connectivity_controller.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/error_view.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JSRWebViewController>();
    final connectivity = Get.find<ConnectivityController>();

    return Obx(() {
      if (!connectivity.isConnected.value) {
        return _buildNoInternetInline(controller);
      }

      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final shouldExit = await controller.handleBackPress();
          if (shouldExit) {
            Get.dialog(
              _buildExitDialog(),
              barrierDismissible: false,
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(controller),
          body: Stack(
            children: [
              Obx(() {
                if (controller.hasError.value) {
                  return ErrorView(
                    message: controller.errorMessage.value,
                    onRetry: controller.reload,
                  );
                }
                return WebViewWidget(
                  controller: controller.webViewController,
                );
              }),

              Obx(() {
                if (controller.isLoading.value) {
                  return LoadingOverlay(
                    progress: controller.loadingProgress.value,
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(controller),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar(JSRWebViewController controller) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      title: Column(
        children: [
          const Text(
            'JSR Students Group',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          Obx(() => Text(
                _cleanUrl(controller.currentUrl.value),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 11,
                ),
              )),
        ],
      ),
      centerTitle: true,
      actions: [
        Obx(() => controller.isLoading.value
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: controller.reload,
                tooltip: 'Reload',
              )),
      ],
    );
  }

  Widget _buildBottomBar(JSRWebViewController controller) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavButton(
            icon: Icons.home_rounded,
            onTap: controller.loadHome,
          ),

          Obx(() => _NavButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: controller.canGoBack.value ? controller.goBack : null,
              )),

          Obx(() => _NavButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap:
                    controller.canGoForward.value ? controller.goForward : null,
              )),

          // _NavButton(
          //   icon: Icons.share_rounded,
          //   onTap: () {
          //     Get.snackbar(
          //       'Share',
          //       'jsrstudentsgroup.com',
          //       snackPosition: SnackPosition.BOTTOM,
          //       backgroundColor: AppTheme.primaryColor,
          //       colorText: Colors.white,
          //       margin: const EdgeInsets.all(12),
          //       borderRadius: 10,
          //       duration: const Duration(seconds: 2),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildNoInternetInline(JSRWebViewController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSR Students Group'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No internet connection!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please turn on the internet.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: controller.reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExitDialog() {
    return AlertDialog(
      title: const Text('Close the app?'),
      content: const Text('Do you want to close the JSR Students Group app?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Yes'),
        ),
      ],
    );
  }

  String _cleanUrl(String url) {
    return url
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .replaceAll('www.', '');
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: onTap != null ? Colors.white : Colors.white30,
        size: 22,
      ),
      onPressed: onTap,
    );
  }
}
