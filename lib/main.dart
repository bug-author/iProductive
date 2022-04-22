import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//
import 'package:iproductive/pages/home_page.dart';
import 'package:iproductive/pages/sign_in.dart';
import 'package:iproductive/services/auth_service.dart';

void main() async {
  // * make sure all widgets are bound
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //
  AuthClass authClass = AuthClass();
  Widget currentPage = const SignInPage();

  @override
  void initState() {
    super.initState();
    // authClass.signOut();
    checkLogin();
  }

  checkLogin() async {
    String? token = await authClass.getToken();

    if (token != null) {
      setState(() {
        currentPage = const HomePage();
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
