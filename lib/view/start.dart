import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:flutter_demo1/utils/store_util.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple]),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 10,
            color: Colors.white,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText('PYZYTH'),
            ],
            totalRepeatCount: 2,
            onFinished: () {
              readData('token').then((value) {
                print(value);
                if (value != null) {
                  Get.offNamed('/home');
                } else {
                  Get.offNamed('/login');
                }
              });
            },
            isRepeatingAnimation: true,
          ),
        ));
  }
}
