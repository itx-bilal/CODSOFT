import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _categorykey = GlobalKey<FormState>();
  final GlobalKey<FormState> _amountkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _Datekey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionkey = GlobalKey<FormState>();
  var _categoryController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _amountController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text('Add Expense',style: TextStyle(color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text('Add Expense',style: TextStyle(color: Colors.teal,fontSize: 25),),
              SizedBox(height: 40,),
              Container(
                color: Color(0xff99EDC3),
                width: double.infinity,
                child: Form(
                  key: _categorykey,
                  child: TextFormField(
                    controller: _categoryController,
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.teal),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffEDF7F6),
                      prefixIcon: Icon(Icons.category,color: Colors.teal,),
                      labelText: "Title",
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
                        return 'Please enter category';
                      }
                      if(value!.length>25) {
                        return 'Title is too long';
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
                  key: _descriptionkey,
                  child: TextFormField(
                    controller: _descriptionController,
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.teal),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffEDF7F6),
                      prefixIcon: Icon(Icons.description,color: Colors.teal,),
                      labelText: "Description",
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
                      if(value!.length>75) {
                        return 'Please provide small description';
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
                  key: _amountkey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.teal),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffEDF7F6),
                      prefixIcon: Icon(Icons.monetization_on,color: Colors.teal,),
                      labelText: "Amount",
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
                        return 'Please enter amount';
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
                  key: _Datekey,
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.teal),
                    controller: _dateController,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffEDF7F6),
                      prefixIcon: Icon(Icons.trending_up,color: Colors.teal,),
                      labelText: "Select Date",
                      labelStyle: TextStyle(color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.date_range_outlined,color: Colors.teal,),
                        onPressed: () async {
                          var results = await showCalendarDatePicker2Dialog(
                            dialogBackgroundColor: Colors.teal,
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                                selectedDayTextStyle: TextStyle(color: Colors.black),
                                selectedDayHighlightColor: Color(0xff99EDC3),
                                selectedRangeHighlightColor: Color(0xff99EDC3),
                                selectedYearTextStyle: TextStyle(color: Color(0xff99EDC3)),
                                yearTextStyle: TextStyle(color: Color(0xff99EDC3)),
                                dayTextStyle: TextStyle(color: Colors.white),
                                weekdayLabelTextStyle: TextStyle(color: Colors.white),
                                okButtonTextStyle: TextStyle(color: Color(0xff99EDC3),fontSize: 15)
                            ),
                            dialogSize: const Size(300, 300),
                            value: [_selectedDate],
                            borderRadius: BorderRadius.circular(15),
                          );
                          if (results != null && results.isNotEmpty) {
                            _selectedDate = results[0];
                            final formattedDate = DateFormat.yMMMMd().format(_selectedDate!);
                            _dateController.text = formattedDate;
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return 'Please Select Date';
                      }
                      if (_selectedDate == null) {
                        return 'Please select date from calendar';
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
                      if(_categorykey.currentState!.validate() && _amountkey.currentState!.validate()&&_Datekey.currentState!.validate()&&_descriptionkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await FirebaseFirestore.instance.collection('user_expenses').doc(user?.uid).collection('expenses').add({
                          'Category': 'expense',
                          'Category Name': _categoryController.text,
                          'Description': _descriptionController.text,
                          'Amount': _amountController.text,
                          'Date': _selectedDate,
                        }).then((value) {
                          _categoryController.clear();
                          _descriptionController.clear();
                          _amountController.clear();
                          _dateController.clear();
                        }).onError((error, stackTrace) {
                          print(error);
                        }).whenComplete(() {
                          setState(() {
                            loading = false;
                          });
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                        });
                      }
                    }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Add',style: TextStyle(color: Colors.white,),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}