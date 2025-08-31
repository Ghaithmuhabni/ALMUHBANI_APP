import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/auth/login_page.dart';
import 'package:flutter_application_1/branch/branch_details.dart';
import 'package:flutter_application_1/branch/branchs_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المهباني',
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF8B0000)),
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/': (context) => BranchesPage(),
        '/branch-details': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return BranchDetailsPage(branch: args);
        },
      },
    );
  }
}
