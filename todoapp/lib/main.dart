import 'package:ToDoApp/my_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ToDoApp/add_task_screen.dart';
import 'package:ToDoApp/edit_task_screen.dart';
import 'package:ToDoApp/login_screen.dart';
import 'package:ToDoApp/splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:ToDoApp/user_model.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key:key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var searchController = TextEditingController();
  String search = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? userData;
  CollectionReference? userTasksCollection;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchUserData();
    });
    final User? user = FirebaseAuth.instance.currentUser;
    userTasksCollection = FirebaseFirestore.instance.collection('user_tasks').doc(user?.uid).collection('tasks');
  }

  void fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users_accounts')
        .doc(user?.uid)
        .get();

    userData = UserModel(
      name: userDataSnapshot['Name'] ?? 'User',
      email: userDataSnapshot['Email'],
      imageUrl: userDataSnapshot['Image'],
    );

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen(),));
                      },
                      child: Hero(
                        tag: 'profile',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green,
                              width: 1, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: userData?.imageUrl != null
                                ? Image.network(userData!.imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/error_image.png',fit: BoxFit.fitWidth,);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ).image
                                : Image.asset('assets/images/pic8.png').image,
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(width: 15,),
                    Expanded(flex:8,child: Text('Hello ${userData?.name ?? 'User'}',style: TextStyle(fontSize: 20,color: Colors.white),)),
                    Expanded(child: IconButton(color: Colors.white,onPressed: () async{
                      await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          title: Text('Logout Confirmation',style: TextStyle(color: Colors.green),),
                          content: Text('Are you sure you want to logout your account?',style: TextStyle(color: Colors.white),),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel',style: TextStyle(color: Colors.grey),),
                            ),
                            TextButton(
                              onPressed: () async{
                                _auth.signOut().then((value) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Logout',style: TextStyle(color: Colors.green),),
                            ),
                          ],
                        );
                      },
                      );
                    }, icon: Icon(Icons.logout))),
                  ],
                ),
                SizedBox(height: 10,),
                Text('Your to-do list awaits! What epic goals are you planning to crush today?',style: TextStyle(fontSize: 20,color: Colors.green),),
                SizedBox(height: 10,),
                Form(
                  child: TextFormField(
                    controller: searchController,
                    cursorColor: Colors.green,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      prefixIcon: Icon(Icons.search,color: Colors.white,),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 5
                        )
                      ),
                    ),
                    onChanged: (String? value) {
                      print(value);
                      setState(() {
                        search = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Icon(Icons.note_alt_rounded,color: Colors.white,),
                    SizedBox(width: 5,),
                    Text('My Tasks',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ],
                ),
                //SizedBox(height: 5,),
          Expanded(
            child: StreamBuilder(
              stream: userTasksCollection?.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.green,));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                else if(!snapshot.hasData||snapshot.data!.docs.isEmpty) {
                  return Center(child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          child: Image.asset('assets/images/no_tasks.png'),
                        ),
                        Text('No Task',style: TextStyle(fontSize: 25,color: Colors.green),)
                      ],
                    ),
                  ));
                }
                else {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      DocumentSnapshot task = snapshot.data!.docs[index];
                      String title = task['Title'] ?? 'No Title';
                      String title_position = task['Title'];
                      String desc_position = task['Description'];
                      if(searchController.text.isEmpty) {
                        return Slidable(
                          startActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskScreen(task: snapshot.data!.docs[index] as QueryDocumentSnapshot),));
                                  },
                                  backgroundColor: Colors.green,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ]
                          ),
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async{
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey.shade800,
                                        title: Text('Delete Task',style: TextStyle(color: Colors.green),),
                                        content: Text('Are you sure you want to delete this task?',style: TextStyle(color: Colors.white),),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel',style: TextStyle(color: Colors.grey),),
                                          ),
                                          TextButton(
                                            onPressed: () async{
                                              Navigator.of(context).pop();
                                              await userTasksCollection?.doc(task.id).delete();
                                            },
                                            child: Text('Delete',style: TextStyle(color: Colors.green),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              )
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              tileColor: Colors.grey.shade800,
                              leading: Container(
                                width: 48, // Adjust the width as needed
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(title.isNotEmpty ? title[0].toUpperCase() : '', style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              title: Text(title, style: TextStyle(color: Colors.green,fontSize: 18)),
                              subtitle: Text(task['Description'] ?? 'No Description', style: TextStyle(color: Colors.white,fontSize: 12)),
                              trailing: Text(
                                task['Task Date'] != null
                                    ? DateFormat('MMM dd, yyyy \'at\' hh:mm a').format((task['Task Date'] as Timestamp).toDate())
                                    : 'No Date',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        );
                      }
                      else if(title_position.toLowerCase().contains(searchController.text)||desc_position.toLowerCase().contains(searchController.text)) {
                        return Slidable(
                          startActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskScreen(task: snapshot.data!.docs[index] as QueryDocumentSnapshot),));
                                  },
                                  backgroundColor: Colors.green,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ]
                          ),
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async{
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey.shade800,
                                        title: Text('Delete Task',style: TextStyle(color: Colors.green),),
                                        content: Text('Are you sure you want to delete this task?',style: TextStyle(color: Colors.white),),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Don't delete
                                            },
                                            child: Text('Cancel',style: TextStyle(color: Colors.grey),),
                                          ),
                                          TextButton(
                                            onPressed: () async{
                                              await userTasksCollection?.doc(task.id).delete();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Delete',style: TextStyle(color: Colors.green),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              )
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              tileColor: Colors.grey.shade800,
                              leading: Container(
                                width: 48,
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(title.isNotEmpty ? title[0].toUpperCase() : '', style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              title: Text(title, style: TextStyle(color: Colors.green,fontSize: 18)),
                              subtitle: Text(task['Description'] ?? 'No Description', style: TextStyle(color: Colors.white,fontSize: 12)),
                              trailing: Text(
                                task['Task Date'] != null
                                    ? DateFormat('MMM dd, yyyy \'at\' hh:mm a').format((task['Task Date'] as Timestamp).toDate())
                                    : 'No Date',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(),));
        },
        tooltip: 'Add task',
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
