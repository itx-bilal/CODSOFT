import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipeapp/home_screen.dart';
import 'package:foodrecipeapp/signup_screen.dart';
import 'package:lottie/lottie.dart';

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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),))
        ,);
    }
    else {
      Timer(Duration(seconds: 4),() =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen(),))
        ,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E234F),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Lottie.asset('assets/animations/food_animation.json'),
              ),
              Text('Food Recipe',style: TextStyle(fontSize: 30,color: Colors.orange),),
              SizedBox(height: 15,),
              Container(
                width: 150,
                  height: 150,
                  child: Lottie.asset('assets/animations/loading_animation.json'))
            ],
          ),
        ),
      ),
    );
  }
}