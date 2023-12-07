import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExpenseScreen extends StatefulWidget {
  final DocumentSnapshot details;

  EditExpenseScreen({required this.details});
  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _editcategorykey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editamountkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editDatekey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editdescriptionkey = GlobalKey<FormState>();
  var _editcategoryController = TextEditingController();
  var _editdescriptionController = TextEditingController();
  var _editamountController = TextEditingController();
  TextEditingController _editdateController = TextEditingController();
  DateTime? _editselectedDate;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _editcategoryController.text = widget.details['Category Name'];
    _editdescriptionController.text = widget.details['Description'];
    _editamountController.text = widget.details['Amount'];
    _editselectedDate = (widget.details['Date'] as Timestamp?)?.toDate();

    _editdateController.text = _editselectedDate != null
        ? DateFormat.yMMMMd().format(_editselectedDate!)
        : '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text('Edit Expense',style: TextStyle(color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Hero(
                tag: 'icon',
                child: Container(
                  width:120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.teal
                  ),
                  child: Icon(Icons.trending_up,color: Colors.white,size: 30,),
                ),
              ),
              SizedBox(height: 10,),
              Text('Edit Expense',style: TextStyle(color: Colors.teal,fontSize: 25),),
              SizedBox(height: 40,),
              Container(
                color: Color(0xff99EDC3),
                width: double.infinity,
                child: Form(
                  key: _editcategorykey,
                  child: TextFormField(
                    controller: _editcategoryController,
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
                  key: _editdescriptionkey,
                  child: TextFormField(
                    controller: _editdescriptionController,
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
                  key: _editamountkey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _editamountController,
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
                  key: _editDatekey,
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.teal),
                    controller: _editdateController,
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
                            value: [_editselectedDate],
                            borderRadius: BorderRadius.circular(15),
                          );
                          if (results != null && results.isNotEmpty) {
                            _editselectedDate = results[0];
                            final formattedDate = DateFormat.yMMMMd().format(_editselectedDate!);
                            _editdateController.text = formattedDate;
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return 'Please Select Date';
                      }
                      if (_editselectedDate == null) {
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
                      print('_editselectedDate: $_editselectedDate');
                      if (_editcategorykey.currentState!.validate() &&
                          _editamountkey.currentState!.validate() &&
                          _editDatekey.currentState!.validate() &&
                          _editdescriptionkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });

                        DocumentReference documentReference = widget.details.reference;

                        await documentReference.update({
                          'Category': 'expense',
                          'Category Name': _editcategoryController.text,
                          'Description': _editdescriptionController.text,
                          'Amount': _editamountController.text,
                          'Date': _editselectedDate,
                        }).then((value) {
                          _editcategoryController.clear();
                          _editdescriptionController.clear();
                          _editamountController.clear();
                          _editdateController.clear();
                        }).onError((error, stackTrace) {
                          print(error);
                        }).whenComplete(() {
                          setState(() {
                            loading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                                (route) => false,
                          );
                        });
                      }
                    }, child: loading ? CircularProgressIndicator(color: Colors.white,) : Text('Edit',style: TextStyle(color: Colors.white,),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}