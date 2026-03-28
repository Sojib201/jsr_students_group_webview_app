import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../app/app_theme.dart';

class JSRWebViewController extends GetxController {
  late WebViewController webViewController;

  final RxBool isLoading = true.obs;
  final RxInt loadingProgress = 0.obs;
  final RxBool canGoBack = false.obs;
  final RxBool canGoForward = false.obs;
  final RxString currentUrl = AppConstants.webUrl.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initWebView();
  }

  void _initWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            isLoading.value = true;
            hasError.value = false;
            currentUrl.value = url;
          },
          onProgress: (progress) {
            loadingProgress.value = progress;
            if (progress == 100) {
              isLoading.value = false;
            }
          },
          onPageFinished: (url) async {
            isLoading.value = false;
            canGoBack.value = await webViewController.canGoBack();
            canGoForward.value = await webViewController.canGoForward();
          },
          onWebResourceError: (error) {
            isLoading.value = false;
            hasError.value = true;
            errorMessage.value = error.description;
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConstants.webUrl));
  }

  Future<void> goBack() async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
    }
  }

  Future<void> goForward() async {
    if (await webViewController.canGoForward()) {
      await webViewController.goForward();
    }
  }

  Future<void> reload() async {
    hasError.value = false;
    isLoading.value = true;
    await webViewController.reload();
  }

  Future<void> loadHome() async {
    hasError.value = false;
    isLoading.value = true;
    await webViewController.loadRequest(Uri.parse(AppConstants.webUrl));
  }

  Future<bool> handleBackPress() async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
      return false;
    }
    return true;
  }
}
