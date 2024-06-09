import 'package:get/get.dart';

class SnackbarUtil {
  static void show(String title, String message) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 1),
      animationDuration: const Duration(milliseconds: 700),
    );
  }

  static void hide() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }
}
