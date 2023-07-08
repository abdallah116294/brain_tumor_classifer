import 'dart:async';

import 'package:brain_tumor_classifer/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  goNext() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  startDely() {
    _timer = Timer(const Duration(seconds: 10), () => goNext());
  }

  @override
  void initState() {
    super.initState();
    startDely();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/brain.jpg',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
