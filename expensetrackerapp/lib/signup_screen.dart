import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/image_required_dialog.dart';
import 'package:expensetrackerapp/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _phonenokey = GlobalKey<FormState>();

  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneNoController = TextEditingController();
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
      backgroundColor: Color(0xff99EDC3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    Container(
                        width: 240,
                        height: 150,
                        child: Lottie.asset('assets/animations/signup_animation.json')),
                    SizedBox(height: 15,),
                    Text('Register your Account',style: TextStyle(fontSize: 22,color: Colors.teal),),
                    SizedBox(height: 32,),
                    Stack(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      backgroundColor: Color(0xff99EDC3),
                                      appBar: AppBar(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.teal,
                                        title: Text('Profile Picture',style: TextStyle(color: Colors.white,),),
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
                                    color: Colors.teal
                                ),
                                child: Icon(Icons.camera_alt,color: Colors.white,),
                              ),
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Color(0xff99EDC3),
                      width: double.infinity,
                      child: Form(
                        key: _usernamekey,
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          controller: _usernameController,
                          style: TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffEDF7F6),
                            prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.teal,),
                            labelText: "Full Name",
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
                              return 'Please enter name';
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
                    SizedBox(height: 10,),
                    Container(
                      color: Color(0xff99EDC3),
                      width: double.infinity,
                      child: Form(
                        key: _phonenokey,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.teal,
                          controller: _phoneNoController,
                          style: TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffEDF7F6),
                            prefixIcon: Icon(Icons.phone,color: Colors.teal,),
                            labelText: "Phone No",
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
                              return 'Please Enter Phone Number';
                            }
                            if(value.length<11 || value.length>11) {
                              return 'Invalid Phone Number';
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
                            onPressed: () async {
                              if (isImageSelected()) {
                                if (_usernamekey.currentState!.validate() &&
                                    _emailkey.currentState!.validate() &&
                                    _passwordkey.currentState!.validate() &&
                                _phonenokey.currentState!.validate()
                                ) {
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
                                      'Phone No': _phoneNoController.text
                                    });

                                    setState(() {
                                      image = null;
                                    });
                                    _usernameController.clear();
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _phoneNoController.clear();
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
                                        content: Text('Signup failed: $error',style: TextStyle(color: Colors.teal),),
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
                            child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Register',style: TextStyle(color: Colors.white,),))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",style: TextStyle(color: Colors.grey.shade800),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text('Login',style: TextStyle(color: Colors.teal),),
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
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0xff99EDC3),
          height: 240,
          child: Column(
            children: [
              SizedBox(height: 5,),
              Text('Select Image From',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 18),),
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
                      color: Colors.teal,
                      elevation: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Image.asset('assets/images/gallery.png',width: 80,height: 70,fit: BoxFit.fill,),
                            ),
                            Text('Gallery',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
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
                      color: Colors.teal,
                      elevation: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Image.asset('assets/images/camm.png',width: 80,height: 70,fit: BoxFit.fill),
                            ),
                            Text('Camera',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
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
                          backgroundColor: Colors.teal
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