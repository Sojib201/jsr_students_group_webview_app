import 'package:get/get.dart';
import '../controllers/webview_controller.dart';
import '../controllers/connectivity_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Connectivity Controller - permanent (alive throughout app)
    Get.put<ConnectivityController>(
      ConnectivityController(),
      permanent: true,
    );

    // WebView Controller - lazy loaded
    Get.lazyPut<JSRWebViewController>(
      () => JSRWebViewController(),
    );
  }
}
