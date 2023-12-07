import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ToDoApp/task_success_dialogue.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _titlekey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionkey = GlobalKey<FormState>();
  bool loading = false;
  final User? user = FirebaseAuth.instance.currentUser;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: Text('Add Task',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                    height: 300,
                    child: Image.asset('assets/images/add_task.png')),
                SizedBox(height: 10,),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Form(
                    key: _titlekey,
                    child: TextFormField(
                      cursorColor: Colors.green,
                      controller: titleController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.white),
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
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Form(
                    child: TextFormField(
                      cursorColor: Colors.green,
                      controller: descriptionController,
                      maxLines: 7,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
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
                      onPressed: () async{
                    if(_titlekey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      await FirebaseFirestore.instance.collection('user_tasks').doc(user?.uid).collection('tasks').add({
                        'Title': titleController.text,
                        'Description': descriptionController.text,
                        'Task Date': FieldValue.serverTimestamp()
                      }).then((value) {
                        titleController.clear();
                        descriptionController.clear();
                        showTaskSuccessDialog(context, 'Task Added', 'Your task has been added succcessfully');
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.white,
                            content: Text('Task failed: $error'),
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
                  }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Add',style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}