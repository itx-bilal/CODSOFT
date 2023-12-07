import 'dart:async';
import 'package:expensetrackerapp/home_screen.dart';
import 'package:expensetrackerapp/introduction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  @override
  void initState() {
    Future.delayed(Duration(seconds:2), () {
      setState(() {
        _opacity = 1.0;
      });
    });
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IntroductionScreen()))
        ,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Lottie.asset('assets/animations/splash_animation.json'),
              ),
              AnimatedOpacity(
                  opacity: _opacity,
                  curve: Curves.easeInOut,
                  duration: Duration(seconds: 1),
                  child: Text('spendX',style: TextStyle(fontSize: 30,color: Colors.teal),)),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}