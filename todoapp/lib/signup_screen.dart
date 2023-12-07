import 'dart:io';
import 'package:ToDoApp/image_required_dialogue.dart';
import 'package:ToDoApp/task_success_dialogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ToDoApp/login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passVisible = true;
  bool loading = false;
  final GlobalKey<FormState> _usernamekey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordkey = GlobalKey<FormState>();
  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  File? image;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) return;
    setState(() {
      image = File(pickedImage.path);
    });
  }
  bool isImageSelected() {
    return image != null;
  }

  Future<String?> uploadImage(File image) async {
    try {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('user_profile_images/${user?.uid}');

      UploadTask uploadTask = storageRef.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        final imageUrl = await storageRef.getDownloadURL();
        return imageUrl;
      } else {
        print("Image upload task is not complete");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }


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
                      height: 200,
                      child: Image.asset('assets/images/signup.png')),
                  SizedBox(height: 10,),
                  Text('Signup',style: TextStyle(fontSize: 30,color: Colors.white),),
                  SizedBox(height: 40,),
                  Stack(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      title: Text('My Picture'),
                                      elevation: 0,
                                    ),
                                    body: Center(
                                      child: Hero(
                                        tag: 'My Picture',
                                        child: image == null
                                            ? Image.asset(
                                          'assets/images/pic8.png',
                                          fit: BoxFit.contain,
                                          height: double.infinity,
                                          width: double.infinity,
                                        )
                                            : Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },

                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipOval(
                              child: image != null ? Image.file(image!,fit: BoxFit.cover,) : Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/pic8.png'),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).orientation == Orientation.portrait ? 0 : 0,
                          left: MediaQuery.of(context).orientation == Orientation.portrait ? 210 : 370,
                          child: InkWell(
                            onTap: () {
                              showCustomImageModalBottomSheet(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.grey.shade900
                              ),
                              child: Icon(Icons.camera_alt,color: Colors.white,),
                            ),
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: Form(
                      key: _usernamekey,
                      child: TextFormField(
                        cursorColor: Colors.green,
                        controller: _usernameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          //focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.white,),
                          labelText: "Full Name",
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
                            return 'Please enter name';
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
                          onPressed: () async {
                            if (isImageSelected()) {
                              if (_usernamekey.currentState!.validate() &&
                                  _emailkey.currentState!.validate() &&
                                  _passwordkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                try {
                                  UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );

                                  final imageUrl = await uploadImage(image!);

                                  await FirebaseFirestore.instance
                                      .collection('users_accounts')
                                      .doc(userCredential.user?.uid)
                                      .set({
                                    'Image': imageUrl,
                                    'Name': _usernameController.text,
                                    'Email': _emailController.text,
                                  });

                                  setState(() {
                                    image = null;
                                  });
                                  _usernameController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();

                                  setState(() {
                                    loading = false;
                                  });

                                  showTaskSuccessDialog(context, 'Account Created', 'Your account has been created successfully');
                                } catch (error) {
                                  print("Error during signup: $error");

                                  setState(() {
                                    loading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.white,
                                      content: Text('Signup failed: $error',style: TextStyle(color: Colors.green),),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(17.0),
                                    ),
                                  );
                                }
                              }
                            }
                            else {
                              showImageRequiredDialog(context, 'Image required', 'Please provide your image');
                            }
                          },
                          child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Signup',style: TextStyle(color: Colors.white),))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",style: TextStyle(color: Colors.white),),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text('Login',style: TextStyle(color: Colors.green),),
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
  void showCustomImageModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 240,
          child: Column(
            children: [
              SizedBox(height: 5,),
              Text('Select Image From',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 18),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Image.asset('assets/images/gallery.png',width: 80,height: 70,fit: BoxFit.fill,),
                            ),
                            Text('Gallery',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Image.asset('assets/images/camm.png',width: 80,height: 70,fit: BoxFit.fill),
                            ),
                            Text('Camera',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Cancel',style: TextStyle(color: Colors.white),)))
            ],
          ),
        );
      },
    );
  }
}