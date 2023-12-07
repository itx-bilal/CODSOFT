import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _editemailkey = GlobalKey<FormState>();
  var _editemailController = TextEditingController();
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text('Forgot Password',style: TextStyle(color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Lottie.asset('assets/animations/forgot_animation.json'),
              SizedBox(height: 20,),
              Container(
                color: Color(0xff99EDC3),
                width: double.infinity,
                child: Form(
                  key: _editemailkey,
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    controller: _editemailController,
                    style: TextStyle(color: Colors.teal),
                    decoration: InputDecoration(
                      //focusedBorder: InputBorder.none,
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
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal
                  ),
                  onPressed: () async {
                      if(_editemailkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await _auth.sendPasswordResetEmail(email: _editemailController.text.toString()).then((value) {
                          final snackbar = SnackBar(
                            backgroundColor: Colors.white,
                            content: Text('We have sent you an email for new password',style: TextStyle(color: Colors.teal),),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(17.0),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          _editemailController.clear();
                        }).onError((error, stackTrace) {
                          final snackbar = SnackBar(
                            backgroundColor: Colors.white,
                            content: Text(error.toString(),style: TextStyle(color: Colors.teal),),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(17.0),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }).whenComplete(() {
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                  },
                  child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Reset',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}