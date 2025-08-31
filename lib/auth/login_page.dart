import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/branch/branchs_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<String?> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // نخزن document ID = uid
        .get();

    if (doc.exists) {
      return doc['role']; // "admin" أو "user"
    }
    return null;
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء إدخال البريد الإلكتروني وكلمة المرور"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // تسجيل الدخول عبر Firebase
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // التحقق إذا المستخدم هو الأدمن
      if (email == "admin@gmail.com" && password == "admin12345") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BranchesPage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("أنت لست الأدمن")));
      }
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ أثناء تسجيل الدخول";
      if (e.code == 'user-not-found') {
        message = "البريد الإلكتروني غير مسجل";
      } else if (e.code == 'wrong-password') {
        message = "كلمة المرور غير صحيحة";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5B5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // اللوغو
              Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.redAccent.shade700,
              ),
              const SizedBox(height: 30),

              // عنوان
              Text(
                "تسجيل الدخول",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent.shade700,
                ),
              ),
              const SizedBox(height: 40),

              // حقل البريد الإلكتروني
              TextField(
                textAlign: TextAlign.right,
                controller: _emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "البريد الإلكتروني",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور
              TextField(
                textAlign: TextAlign.right,
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: "كلمة المرور",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // زر تسجيل الدخول
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "تسجيل الدخول",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
