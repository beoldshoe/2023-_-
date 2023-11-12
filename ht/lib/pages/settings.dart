import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 500,
          width: 250,
          child: Lottie.asset("lottie/settings.json"),
        ),
      ),
    );
  }
}