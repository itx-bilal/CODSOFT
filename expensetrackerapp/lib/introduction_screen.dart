import 'package:expensetrackerapp/intro_screen_model.dart';
import 'package:expensetrackerapp/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {

  int currentindex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentindex = index;
                    });
                  },
                  itemBuilder: (_,i) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                              },
                              child: Text('Skip',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal),),
                            ),
                          ),
                          Image.asset(contents[i].image,height: 300),
                          Text(contents[i].title,textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.teal),),
                          SizedBox(height: 20,),
                          Text(contents[i].description,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey.shade700),)
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                      (index) => buildDot(index, context),
                ),
              ),
            ),
            Container(
              height: 55,
              width: double.infinity,
              margin: EdgeInsets.all(40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal
                ),
                  onPressed: () {
                if(currentindex == contents.length -1) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                }
                _controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
              }, child: Text(currentindex == contents.length -1 ? 'Get Started':'Next',style: TextStyle(color: Colors.white),)),
            )
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentindex == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.teal,
      ),
    );
  }
}