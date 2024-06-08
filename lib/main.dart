import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'view/start.dart';
import 'view/login.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: RouteConfig.routes,
      home: StartView(),
      defaultTransition: Transition.rightToLeft,
    );
  }
}
