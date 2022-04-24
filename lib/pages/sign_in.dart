import 'package:flutter/material.dart';
import 'package:iproductive/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:iproductive/pages/home_page.dart';
import 'package:iproductive/pages/sign_up.dart';
import 'package:iproductive/services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthClass authClass = AuthClass();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  bool circular = false;

  // ! to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Container(
          width: size.width,
          height: size.height,
          color: darkGreyClr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🚀 🎯 💪",
                style: TextStyle(
                  fontSize: 44,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "iProductive",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Avenir",
                  fontSize: 35,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Maintain better workflows!",
                style: TextStyle(
                  color: redClr,
                  fontFamily: "Avenir",
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white70,
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email', border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white70,
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Enter your password',
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    firebase_auth.UserCredential userCredential =
                        await firebaseAuth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);

                    setState(() {
                      circular = false;
                    });

                    authClass.storeTokenAndData(userCredential);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => HomePage(),
                        ),
                        (route) => false);
                  } catch (e) {
                    final snackbar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                    color: darkRedClr,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: const [
                    Expanded(
                      child: Divider(color: Colors.white70, thickness: 1),
                    ),
                    Text('  Not Registered? Sign Up instead!  ',
                        style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Divider(color: Colors.white70, thickness: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // todo
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignUpPage()),
                      (route) => false);
                },
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                    color: darkRedClr,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w600,
                    ),
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
