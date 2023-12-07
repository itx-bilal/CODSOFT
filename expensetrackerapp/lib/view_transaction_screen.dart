import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/edit_expense_screen.dart';
import 'package:expensetrackerapp/edit_income_screen.dart';
import 'package:expensetrackerapp/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewTransactionScreen extends StatelessWidget {
  final DocumentSnapshot details;
  final icon;

  ViewTransactionScreen({required this.details,required this.icon});
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? transactionData = details.data() as Map<String, dynamic>?;
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text('Category Details',style: TextStyle(color: Colors.white,),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    child: Icon(icon,color: Colors.white,size: 30,),
                  ),
                ),
                SizedBox(height: 20,),
                Text(transactionData!['Category Name'],style: TextStyle(fontSize: 20,color: Colors.teal),),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 30,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.teal),
                          children: [
                            TextSpan(text: 'Title'),
                            WidgetSpan(
                              child: SizedBox(width: 8),
                            ),
                            TextSpan(
                              text: '${transactionData!['Category Name']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 30,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.teal),
                          children: [
                            TextSpan(text: 'Amount'),
                            WidgetSpan(
                              child: SizedBox(width: 8),
                            ),
                            TextSpan(
                              text: 'PKR ${transactionData!['Amount']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 30,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.teal),
                          children: [
                            TextSpan(text: 'Date'),
                            WidgetSpan(
                              child: SizedBox(width: 8),
                            ),
                            TextSpan(
                              text: '${DateFormat('MMM dd, yyyy').format((transactionData!['Date'] as Timestamp).toDate())}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 30,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.teal),
                          children: [
                            TextSpan(text: 'Description'),
                            WidgetSpan(
                              child: SizedBox(width: 8),
                            ),
                            TextSpan(
                              text: '${transactionData!['Description']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                          ),
                          onPressed: () async{
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.teal,
                                  title: Text('Confirm Deletion',style: TextStyle(color: Color(0xff99EDC3)),),
                                  content: Text('Are you sure you want to delete this transaction?',style: TextStyle(color: Colors.white),),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Don't delete
                                      },
                                      child: Text('Cancel',style: TextStyle(color: Colors.grey),),
                                    ),
                                    TextButton(
                                      onPressed: () async{
                                        try {
                                          DocumentReference documentReference = details.reference;
                                          await documentReference.delete();
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Failed to delete transaction: $e'),
                                          ));
                                        }
                                      },
                                      child: Text('Delete',style: TextStyle(color: Color(0xff99EDC3)),),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, child: Text('Delete',style: TextStyle(color: Colors.white,),)),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: 120,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal
                          ),
                          onPressed: () async{
                            if (transactionData!['Category'] == 'income') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditIncomeScreen(details: details),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditExpenseScreen(details: details),
                                ),
                              );
                            }
                          }, child: Text('Edit',style: TextStyle(color: Colors.white,),)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}