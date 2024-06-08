import 'package:get/get.dart';
import '../view/start.dart';
import '../view/home.dart';
import '../view/login.dart';

class RouteConfig {
  static final routes = [
    GetPage(
      name: '/start',
      page: () => const StartView(),
    ),
    GetPage(
      name: "/home",
      page: () => const HomeView(),
    ),
    GetPage(
      name: "/login",
      page: () => const LoginView(),
    )
  ];
}
