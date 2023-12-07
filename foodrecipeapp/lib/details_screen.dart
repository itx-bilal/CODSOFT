import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String chef;
  final String image;
  final String name;
  final String calories;
  final String ingredients;
  final String time;
  final String aboutRecipe;
  final String cookingMethod;

  DetailScreen({
    required this.chef,
    required this.image,
    required this.name,
    required this.calories,
    required this.ingredients,
    required this.time,
    required this.aboutRecipe,
    required this.cookingMethod,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Hero(
      tag: image,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.55,
                child: Image.asset(image,fit: BoxFit.cover,),
              ),
              DraggableScrollableSheet(
                maxChildSize: 1,
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  builder: (context,controller) {
                  return SingleChildScrollView(
                    controller: controller,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      //height: 800,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
                        color: Color(0xFF0E234F),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.orange),),
                              Spacer(),
                              IconButton(onPressed: () {}, icon: Icon(Icons.favorite),color: Colors.redAccent,iconSize: 30,)
                            ],
                          ),
                          SizedBox(height: 2,),
                          Text(chef,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey.shade300),),
                          SizedBox(height: 2,),
                          Row(
                            children: [
                              Icon(Icons.star,color: Colors.orange,size: 15,),
                              Icon(Icons.star,color: Colors.orange,size: 15,),
                              Icon(Icons.star,color: Colors.orange,size: 15,),
                              Icon(Icons.star,color: Colors.orange,size: 15,),
                              Icon(Icons.star,color: Colors.grey[400],size: 15,)
                            ],
                          ),
                          SizedBox(height: 24,),
                          Container(
                            child: Row(
                              children: [
                                Expanded(child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.orange)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      Text('Calories',style: TextStyle(color: Colors.orange),),
                                      Text(calories,style: TextStyle(color: Colors.grey[300],fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                )
                                ),
                                SizedBox(width: 10,),
                                Expanded(child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.orange)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      Text('Ingrediants',style: TextStyle(color: Colors.orange),),
                                      Text(ingredients,style: TextStyle(color: Colors.grey[300],fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                )
                                ),
                                SizedBox(width: 10,),
                                Expanded(child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.orange)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      Text('Time',style: TextStyle(color: Colors.orange),),
                                      Text(time,style: TextStyle(color: Colors.grey[300],fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24,),
                          Text('About Recipe',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.orange),),
                          SizedBox(height: 4,),
                          Text(aboutRecipe,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey.shade300),),
                          SizedBox(height: 24,),
                          Text('Cooking Method',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.orange),),
                          SizedBox(height: 4,),
                          Text(cookingMethod,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey.shade300),)
                        ],
                      ),
                    ),
                  );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}