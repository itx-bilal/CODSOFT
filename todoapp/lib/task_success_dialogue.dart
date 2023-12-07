import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TaskSuccessDialog extends StatelessWidget {

  final String heading;
  final String subheading;

  TaskSuccessDialog({required this.heading, required this.subheading});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Lottie.asset('assets/animations/task_success.json'),
            ),
            Center(child: Text('$heading',style: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold),)),
            SizedBox(height: 5,),
            Center(child: Text('$subheading',style: TextStyle(fontSize: 12,color: Colors.grey),)),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green
                  ),
                  onPressed: () {
                Navigator.pop(context);
              }, child: Text('Okay',style: TextStyle(color: Colors.white),)),
            )
          ],
        ),
      ),
    );
  }
}

void showTaskSuccessDialog(BuildContext context, String heading, String subheading) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TaskSuccessDialog(heading: heading,subheading: subheading,);
    },
  );
}
