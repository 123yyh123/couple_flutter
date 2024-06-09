import 'package:flutter_demo1/model/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo1/apis/app.dart';
import 'package:flutter_demo1/utils/loading_util.dart';
import 'package:flutter_demo1/utils/store_util.dart';
import 'package:flutter_demo1/utils/json_util.dart';
import 'package:flutter_demo1/utils/snackbar_util.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  bool isPasswordVisible = false;
  bool isAllowLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
      });
      if (email.isNotEmpty && password.isNotEmpty) {
        setState(() {
          isAllowLogin = true;
        });
      } else {
        setState(() {
          isAllowLogin = false;
        });
      }
    });
    passwordController.addListener(() {
      setState(() {
        password = passwordController.text;
      });
      if (email.isNotEmpty && password.isNotEmpty) {
        setState(() {
          isAllowLogin = true;
        });
      } else {
        setState(() {
          isAllowLogin = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/loginBackground.webp'),
            opacity: 0.8,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: const DecorationImage(
                  image: AssetImage('images/touxiang.png'),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
              height: 80,
              width: 80,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                height: 55,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                    labelText: '请输入邮箱',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    fillColor: Colors.white.withOpacity(0.9),
                    // Colors.white.withOpacity(0.8
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    suffixIcon: emailController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              emailController.clear();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                height: 55,
                child: TextField(
                  obscureText: !isPasswordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                    labelText: '请输入密码',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    fillColor: Colors.white.withOpacity(0.9),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Container(
                height: 50,
                width: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: isAllowLogin
                      ? LinearGradient(colors: [
                          const Color(0xFFF6D9E5).withOpacity(0.9),
                          const Color(0xFFB283BE).withOpacity(0.9),
                        ])
                      : LinearGradient(
                          colors: [
                            const Color(0xFFD3D3D3).withOpacity(0.9),
                            const Color(0xFFD3D3D3).withOpacity(0.9),
                          ],
                        ),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(700, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (email.isEmpty) {
                      SnackbarUtil.show('提示', '请输入邮箱');
                      return;
                    }
                    if (!GetUtils.isEmail(email)) {
                      SnackbarUtil.show('提示', '请输入正确的邮箱');
                      return;
                    }
                    if (password.isEmpty) {
                      SnackbarUtil.show('提示', '请输入密码');
                      return;
                    }
                    UserApi.login(email, password).then((value) {
                      var response = HttpResponse.fromJson(value);
                      if (response.code == 200) {
                        saveData('user', JsonUtil.encode(response.data));
                        saveData('token', response.data['token']);
                        SnackbarUtil.show('提示', '登录成功');
                        Get.offAllNamed('/home');
                      } else {
                        SnackbarUtil.show('提示', response.message);
                      }
                    });
                  },
                  child: const Text('登录',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
