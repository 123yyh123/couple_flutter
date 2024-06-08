import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:get/get.dart';

class LoadingUtil {
  static void show() {
    Get.dialog(
      // 点击背景不关闭
      barrierDismissible: false,
      Center(
        child: LoadingAnimationWidget.halfTriangleDot(
          color: Colors.blue,
          size: 100,
        ),
      ),
    );
  }

  static void hide() {
    Get.back();
  }
}
