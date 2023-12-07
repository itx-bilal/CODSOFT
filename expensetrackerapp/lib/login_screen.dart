import 'package:expensetrackerapp/forgot_password_screen.dart';
import 'package:expensetrackerapp/home_screen.dart';
import 'package:expensetrackerapp/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passVisible = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  final GlobalKey<FormState> _emailkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordkey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                        width: 200,
                        height: 200,
                        child: Lottie.asset('assets/animations/login_animation.json')),
                    SizedBox(height: 20,),
                    Text('Login',style: TextStyle(fontSize: 25,color: Colors.teal),),
                    SizedBox(height: 20,),
                    Container(
                      color: Color(0xff99EDC3),
                      width: double.infinity,
                      child: Form(
                        key: _emailkey,
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          controller: _emailController,
                          style: TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffEDF7F6),
                            prefixIcon: Icon(Icons.email,color: Colors.teal,),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          validator: (value) {
                            if(value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      color: Color(0xff99EDC3),
                      width: double.infinity,
                      child: Form(
                        key: _passwordkey,
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          style: TextStyle(color: Colors.teal),
                          controller: _passwordController,
                          obscureText: passVisible,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffEDF7F6),
                            prefixIcon: Icon(Icons.vpn_key,color: Colors.teal,),
                            suffixIcon: IconButton(
                              color: Colors.teal,
                              onPressed: () {
                                setState(() {
                                  passVisible = !passVisible;
                                });
                              },
                              icon: passVisible
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          validator: (value) {
                            if(value!.isEmpty) {
                              return 'Please Enter Password';
                            }
                            if(value!.length<6) {
                              return 'Password should be atleast 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.065,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal
                          ),
                          onPressed: () {
                            if(_emailkey.currentState!.validate() && _passwordkey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              _auth.signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text
                              ).then((value) {
                                _emailController.clear();
                                _passwordController.clear();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                              }).onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Text('Login failed: $error',style: TextStyle(color: Colors.teal),),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(17.0),
                                  ),
                                );
                              }).whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                              });
                            }
                          }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Login',style: TextStyle(color: Colors.white,),)),
                    ),
                    TextButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),));
                    }, child: Text('Forgot Password',style: TextStyle(color: Colors.teal),)),
                    Text('------------------------ OR ------------------------',style: TextStyle(color: Colors.grey.shade800),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",style: TextStyle(color: Colors.grey.shade800),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                          },
                          child: Text('Signup',style: TextStyle(color: Colors.teal),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}