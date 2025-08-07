import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pop(); // العودة إلى الصفحة السابقة بعد تسجيل الدخول
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Icon(Icons.lock, color: Colors.white, size: 80),
              const SizedBox(height: 24),
              const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.yellow)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF8B0000))
                    : const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Color(0xFF8B0000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
