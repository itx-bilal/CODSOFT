import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipeapp/home_screen.dart';
import 'package:foodrecipeapp/signup_screen.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool passVisible = true;
  bool loading = false;
  final GlobalKey<FormState> _emailkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordkey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E234F),
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
                    Text('Login',style: TextStyle(fontSize: 25,color: Colors.orange),),
                    SizedBox(height: 20,),
                    Container(
                      color: Color(0xFF0E234F),
                      width: double.infinity,
                      child: Form(
                        key: _emailkey,
                        child: TextFormField(
                          cursorColor: Colors.orange,
                          controller: _emailController,
                          style: TextStyle(color: Colors.orange),
                          decoration: InputDecoration(
                            //focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            prefixIcon: Icon(Icons.email,color: Colors.orange,),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.orange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
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
                      color: Color(0xFF0E234F),
                      width: double.infinity,
                      child: Form(
                        key: _passwordkey,
                        child: TextFormField(
                          cursorColor: Colors.orange,
                          style: TextStyle(color: Colors.orange),
                          controller: _passwordController,
                          obscureText: passVisible,
                          decoration: InputDecoration(
                            //focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            prefixIcon: Icon(Icons.vpn_key,color: Colors.orange,),
                            suffixIcon: IconButton(
                              color: Colors.orange,
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
                            labelStyle: TextStyle(color: Colors.orange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
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
                              backgroundColor: Colors.orange
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
                                    content: Text('Login failed: $error',style: TextStyle(color: Colors.orange),),
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
                          }, child: loading ? Lottie.asset('assets/animations/button_animation.json') : Text('Login',style: TextStyle(color: Color(0xFF0E234F),),)),
                    ),
                    TextButton(onPressed: () {}, child: Text('Forgot Password',style: TextStyle(color: Colors.orange),)),
                    Text('------------------------ OR ------------------------',style: TextStyle(color: Colors.white),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",style: TextStyle(color: Colors.white),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                          },
                          child: Text('Signup',style: TextStyle(color: Colors.orange),),
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