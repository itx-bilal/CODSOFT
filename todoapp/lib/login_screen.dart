import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ToDoApp/main.dart';
import 'package:ToDoApp/signup_screen.dart';

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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                      height: 300,
                      child: Image.asset('assets/images/login.png')),
                  Text('Login',style: TextStyle(fontSize: 25,color: Colors.white),),
                  SizedBox(height: 40,),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: Form(
                      key: _emailkey,
                      child: TextFormField(
                        cursorColor: Colors.green,
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          //focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Icon(Icons.email,color: Colors.white,),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
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
                    color: Colors.black,
                    width: double.infinity,
                    child: Form(
                      key: _passwordkey,
                      child: TextFormField(
                        cursorColor: Colors.green,
                        style: TextStyle(color: Colors.white),
                        controller: _passwordController,
                        obscureText: passVisible,
                        decoration: InputDecoration(
                          //focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Icon(Icons.vpn_key,color: Colors.white,),
                          suffixIcon: IconButton(
                            color: Colors.white,
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
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
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
                            backgroundColor: Colors.green
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text('Login failed: $error',style: TextStyle(color: Colors.green),),
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
                        }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Login',style: TextStyle(color: Colors.white),)),
                  ),
                  TextButton(onPressed: () {}, child: Text('Forgot Password',style: TextStyle(color: Colors.green),)),
                  Text('------------------------ OR ------------------------',style: TextStyle(color: Colors.white),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",style: TextStyle(color: Colors.white),),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                        },
                        child: Text('Signup',style: TextStyle(color: Colors.green),),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}