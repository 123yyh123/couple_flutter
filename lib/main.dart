import 'package:flutter/material.dart';
import 'package:flutter_demo1/bindings/controller_binding.dart';
import 'package:get/get.dart';
import 'config/routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'view/start.dart';
import 'view/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: RouteConfig.routes,
      home: const StartView(),
      defaultTransition: Transition.rightToLeft,
      builder: EasyLoading.init(),
      initialBinding: ControllerBinding(),
    );
  }
}
