import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipeapp/image_required_dialogue.dart';
import 'package:foodrecipeapp/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

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
  Future<String?> uploadImage(File imageFile, User? user) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('${user?.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;
      final String downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image during signup: $e');
      return null;
    }
  }


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
                    Container(
                      width: 300,
                        height: 200,
                        child: Lottie.asset('assets/animations/signup_animation.json')),
                    SizedBox(height: 20,),
                    Text('Signup',style: TextStyle(fontSize: 25,color: Colors.orange),),
                    SizedBox(height: 40,),
                    Stack(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      backgroundColor: Color(0xFF0E234F),
                                      appBar: AppBar(
                                        foregroundColor: Color(0xFF0E234F),
                                        backgroundColor: Colors.orange,
                                        title: Text('Profile Picture',style: TextStyle(color: Color(0xFF0E234F),),),
                                        elevation: 0,
                                      ),
                                      body: Center(
                                        child: Hero(
                                          tag: 'picture',
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
                              width: 90,
                              height: 90,
                              child: Hero(
                                tag: 'picture',
                                child: ClipOval(
                                  child: image != null ? Image.file(image!,fit: BoxFit.cover,) : Container(
                                    width: 90,
                                    height: 90,
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
                        ),
                        Positioned(
                            top: MediaQuery.of(context).orientation == Orientation.portrait ? 0 : 0,
                            left: MediaQuery.of(context).orientation == Orientation.portrait ? 190 : 370,
                            child: InkWell(
                              onTap: () {
                                showCustomImageModalBottomSheet(context);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.orange
                                ),
                                child: Icon(Icons.camera_alt,color: Colors.white,),
                              ),
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Color(0xFF0E234F),
                      width: double.infinity,
                      child: Form(
                        key: _usernamekey,
                        child: TextFormField(
                          cursorColor: Colors.orange,
                          controller: _usernameController,
                          style: TextStyle(color: Colors.orange),
                          decoration: InputDecoration(
                            //focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.orange,),
                            labelText: "Full Name",
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
                              return 'Please enter name';
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

                                    final imageUrl = await uploadImage(image!,user);

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

                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

                                  } catch (error) {
                                    print("Error during signup: $error");

                                    setState(() {
                                      loading = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Text('Signup failed: $error',style: TextStyle(color: Colors.orange),),
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
                            child: loading ? Lottie.asset('assets/animations/button_animation.json') : Text('Signup',style: TextStyle(color: Color(0xFF0E234F),),))),
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
                          child: Text('Login',style: TextStyle(color: Colors.orange),),
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
  void showCustomImageModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0xFF0E234F),
          height: 240,
          child: Column(
            children: [
              SizedBox(height: 5,),
              Text('Select Image From',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 18),),
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
                            Text('Gallery',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),)
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
                            Text('Camera',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange
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