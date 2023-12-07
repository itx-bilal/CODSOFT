import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool loading = false;
  final GlobalKey<FormState> _editusernamekey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editemailkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editphonenokey = GlobalKey<FormState>();
  var _editusernameController = TextEditingController();
  var _editemailController = TextEditingController();
  var _editphoneNoController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  File? image;
  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) return;
    setState(() {
      image = File(pickedImage.path);
    });
  }
  Future<String?> uploadImage(File imageFile, User? user) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('${user?.uid}.jpg');

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;
      final String downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image during editing: $e');
      return null;
    }
  }


  bool isImageSelected() {
    return image != null;
  }
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String? imageUrl;
  void getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;


    if (user != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users_accounts')
          .doc(user.uid)
          .get();

      Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;

      _editusernameController.text = userData['Name'] ?? '';
      _editemailController.text = userData['Email'] ?? '';
      _editphoneNoController.text = userData['Phone No'] ?? '';
      if (userData['Image'] != null) {
        setState(() {
          imageUrl = userData['Image'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text('Edit Profile',style: TextStyle(color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Lottie.asset('assets/animations/edit_animation.json'),
              SizedBox(height: 10,),
              Text('Edit Profile',style: TextStyle(color: Colors.teal,fontSize: 25),),
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
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  title: Text('Profile Picture',style: TextStyle(color: Colors.white),),
                                  elevation: 0,
                                ),
                                body: Center(
                                  child: image != null ?
                                  Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ) :imageUrl != null
                                      ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  )
                                      : Image.asset(
                                    'assets/images/pic8.png',
                                    fit: BoxFit.contain,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Hero(
                          tag: 'profile',
                          child: ClipOval(
                            child: image != null ? Image.file(image!,fit: BoxFit.cover,) :imageUrl != null
                                ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/pic8.png'),
                                  fit: BoxFit.cover,
                                ),
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.teal
                          ),
                          child: Icon(Icons.edit,color: Colors.white,),
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
                  key: _editusernamekey,
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    controller: _editusernameController,
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
                  key: _editemailkey,
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    controller: _editemailController,
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
                  key: _editphonenokey,
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    controller: _editphoneNoController,
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
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.065,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal
                    ),
                    onPressed: () async{
                      if(_editusernamekey.currentState!.validate()&&_editemailkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        if(user!=null) {
                          try {
                            String newImageUrl = imageUrl!;
                            if (image != null) {
                              newImageUrl = (await uploadImage(image!,user))!;
                            }
                            await FirebaseFirestore.instance.collection('users_accounts').doc(user?.uid).update({
                              'Name': _editusernameController.text,
                              'Email': _editemailController.text,
                              'Image': newImageUrl,
                              'Phone No': _editphoneNoController.text
                            }).then((value) {

                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text('Updation failed: $error',style: TextStyle(color: Colors.teal),),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(17.0),
                                ),
                              );
                            }).whenComplete(() {
                              setState(() {
                                loading = false;
                              });
                            });
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                          }
                          catch(e) {
                            print('Error updating user data: $e');
                          }
                        }
                      }
                    }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Edit',style: TextStyle(color: Colors.white,),)),
              ),
            ],
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