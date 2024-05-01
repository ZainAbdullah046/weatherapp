import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherapp/weather.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<splashScreen> {
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const weather()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
