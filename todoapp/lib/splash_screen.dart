import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ToDoApp/login_screen.dart';
import 'package:ToDoApp/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if(user!=null) {
      Timer(Duration(seconds: 4),() =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),))
        ,);
    }
    else {
      Timer(Duration(seconds: 4),() =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),))
        ,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Lottie.asset('assets/animations/todo_splash.json'),
              ),
              Text('ToDo App',style: TextStyle(fontSize: 30,color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}