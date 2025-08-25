import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/branch/branchs_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // إعداد الانيميشن
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // مدة الظهور/الاختفاء
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // تشغيل الانيميشن
    _controller.forward();

    // الانتقال للصفحة الرئيسية بعد 3 ثواني
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BranchesPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5B5), // لون الخلفية
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'images/logo1.png', // ضع مسار اللوغو
            width: double.infinity,
            height: 220,
          ),
        ),
      ),
    );
  }
}
