import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReportSuccessDialog extends StatelessWidget {

  final String heading;
  final String subheading;

  ReportSuccessDialog({required this.heading, required this.subheading});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xffEDF7F6),
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
              child: Lottie.asset('assets/animations/success_animation.json'),
            ),
            Center(child: Text('$heading',style: TextStyle(fontSize: 20,color: Colors.teal,fontWeight: FontWeight.bold),)),
            SizedBox(height: 5,),
            Center(child: Text('$subheading',style: TextStyle(fontSize: 12,color: Colors.grey.shade800),)),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal
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

void showReportSuccessDialog(BuildContext context, String heading, String subheading) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ReportSuccessDialog(heading: heading,subheading: subheading,);
    },
  );
}
