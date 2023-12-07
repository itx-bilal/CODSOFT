import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/edit_profile_screen.dart';
import 'package:expensetrackerapp/login_screen.dart';
import 'package:expensetrackerapp/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserModel? userData;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchUserData();
    });
  }

  void fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users_accounts')
        .doc(user?.uid)
        .get();

    userData = UserModel(
      name: userDataSnapshot['Name'],
      email: userDataSnapshot['Email'],
      imageUrl: userDataSnapshot['Image'],
      phone: userDataSnapshot['Phone No']
    );

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text('My Profile',style: TextStyle(color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.teal,
                    width: 4,
                  ),
                ),
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Hero(
                    tag: 'profile',
                    child: ClipOval(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: userData?.imageUrl != null
                            ? Image.network(
                          userData!.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              size: 40,
                              color: Colors.teal,
                            );
                          },
                        )
                            : Image.asset(
                          'assets/images/pic8.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Center(child: Text(userData?.name ?? 'Loading...',style: TextStyle(fontSize: 25,color: Colors.teal),)),
            SizedBox(height: 15,),
            Container(
              width: 200,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                  }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit,size: 15,color:Colors.white,),
                  SizedBox(width: 5,),
                  Text('Edit Profile',style: TextStyle(color: Colors.white,),),
                ],
              )),
            ),
            SizedBox(height: 40,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                color: Colors.teal,
              ),
              width: 330,
              height: 280,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Name', style: TextStyle(color: Colors.white)),
                            Text(userData?.name ?? 'Loading...', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Email', style: TextStyle(color: Colors.white)),
                            Text(userData?.email ?? 'Loading...', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone No', style: TextStyle(color: Colors.white)),
                            Text(userData?.phone ?? 'Loading...', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Divider(height: 80, thickness: 2, indent: 1.0, endIndent: 1.0,color: Colors.white,),
                        Center(
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                              ),
                              onPressed: () async{
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.teal,
                                      title: Text('Logout Confirmation',style: TextStyle(color: Color(0xff99EDC3)),),
                                      content: Text('Are you sure you want to logout your account?',style: TextStyle(color: Colors.white),),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel',style: TextStyle(color: Colors.white),),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            _auth.signOut().then((value) {
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Logout',style: TextStyle(color: Color(0xff99EDC3)),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }, child: Text('Logout',style: TextStyle(color: Colors.white),)),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                  itemCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}