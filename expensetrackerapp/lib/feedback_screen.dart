import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/success_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
  final GlobalKey<FormState> _feedbackkey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedCategory = 'General';
  final List<String> _feedbackCategories = [
    'General',
    'Bug Report',
    'Feature Request',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Color(0xff99EDC3),
     appBar: AppBar(
       foregroundColor: Colors.white,
       backgroundColor: Colors.teal,
       title: Text('Feedback',style: TextStyle(color: Colors.white,),),
     ),
     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(12.0),
         child: Column(
           children: [
             Lottie.asset('assets/animations/feedback_animation.json'),
             SizedBox(height: 8,),
             Text('Feedback',style: TextStyle(fontSize: 22,color: Colors.teal),),
             SizedBox(height: 20,),
             DropdownButtonFormField<String>(
               value: _selectedCategory,
               items: _feedbackCategories.map((category) {
                 return DropdownMenuItem<String>(
                   value: category,
                   child: Text(category,style: TextStyle(color: Colors.teal),),
                 );
               }).toList(),
               decoration: InputDecoration(
                 enabledBorder: InputBorder.none,
                 filled: true,
                 fillColor: Color(0xffEDF7F6),
                 prefixIcon: Icon(Icons.category,color: Colors.teal,),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(2),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.teal),
                   borderRadius: BorderRadius.circular(2),
                 ),
               ),
               onChanged: (value) {
                 setState(() {
                   _selectedCategory = value!;
                 });
               },
             ),
             SizedBox(height: 10,),
             Container(
               width: double.infinity,
               color: Color(0xff99EDC3),
               child: Form(
                 key: _feedbackkey,
                 child: TextFormField(
                   cursorColor: Colors.teal,
                   style: TextStyle(color: Colors.teal),
                   controller: _feedbackController,
                   maxLines: 5,
                   decoration: InputDecoration(
                       enabledBorder: InputBorder.none,
                       filled: true,
                       fillColor: Color(0xffEDF7F6),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(2),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.teal),
                         borderRadius: BorderRadius.circular(2),
                       ),
                     hintText: 'Enter your feedback here...',
                     hintStyle: TextStyle(color: Colors.teal)
                   ),
                   validator: (value) {
                     if(value!.isEmpty) {
                       return "Please enter feedback";
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
                     if(_feedbackkey.currentState!.validate()) {
                       _selectedCategory = 'General';
                       setState(() {
                         loading = true;
                       });
                       await FirebaseFirestore.instance.collection('users_feedback').doc(user?.uid).collection('feedback').add({
                         'Category': _selectedCategory,
                         'Feedback': _feedbackController.text
                       }).then((value) {
                         _selectedCategory = 'General';
                         _feedbackController.clear();
                         showReportSuccessDialog(context,"Thankyou!","Your feedback has been submitted");
                       }).onError((error, stackTrace) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text(error.toString()),
                             duration: Duration(seconds: 2),
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
                   }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Submit',style: TextStyle(color: Colors.white,),)),
             ),
           ],
         ),
       ),
     ),
   );
  }
}