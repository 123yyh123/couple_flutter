import 'package:flutter_demo1/utils/request.dart';

class UserApi {
  static Future login(String email, String password) async {
    return await Request().request(
      "/user/login",
      method: DioMethod.post,
      data: {"email": email, "password": password},
    );
  }

  static Future register(String email, String password, String code) async {
    return await Request().request(
      "/user/register",
      method: DioMethod.post,
      data: {"email": email, "password": password, "code": code},
    );
  }
}
