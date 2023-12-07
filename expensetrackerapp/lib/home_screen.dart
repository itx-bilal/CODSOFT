import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackerapp/add_expense_screen.dart';
import 'package:expensetrackerapp/add_income_screen.dart';
import 'package:expensetrackerapp/expense_history_screen.dart';
import 'package:expensetrackerapp/feedback_screen.dart';
import 'package:expensetrackerapp/income_history_screen.dart';
import 'package:expensetrackerapp/login_screen.dart';
import 'package:expensetrackerapp/my_profile_screen.dart';
import 'package:expensetrackerapp/user_model.dart';
import 'package:expensetrackerapp/view_transaction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userData;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String search = '';
  var searchController = TextEditingController();

  List<DocumentSnapshot> transactions = [];
  double currentBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchUserData();
      fetchTransactions();
    });
  }

  void fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users_accounts')
        .doc(user?.uid)
        .get();

    userData = UserModel(
      name: userDataSnapshot['Name'],
      email: userDataSnapshot['Email'],
      imageUrl: userDataSnapshot['Image'],
      phone: userDataSnapshot['Phone No'],
    );
    setState(() {});
  }

  void fetchTransactions() async {
    final expensesCollection =
    FirebaseFirestore.instance.collection('user_expenses').doc(userId).collection('expenses');
    final incomesCollection =
    FirebaseFirestore.instance.collection('user_incomes').doc(userId).collection('incomes');

    QuerySnapshot expensesSnapshot = await expensesCollection.get();
    QuerySnapshot incomesSnapshot = await incomesCollection.get();
    setState(() {
      transactions = [...expensesSnapshot.docs, ...incomesSnapshot.docs];
    });

    transactions.sort((a, b) {
      Timestamp aTimestamp = a['Date'];
      Timestamp bTimestamp = b['Date'];
      return bTimestamp.compareTo(aTimestamp);
    });

    currentBalance = calculateCurrentBalance();
    totalIncome = calculateTotalIncome();
    totalExpense = calculateTotalExpense();
    setState(() {});
  }

  double calculateCurrentBalance() {
    double balance = 0.0;
    for (var transaction in transactions) {
      double amount = double.parse(transaction['Amount']);
      String category = transaction['Category'];

      if (category == 'income') {
        balance += amount;
      } else {
        balance -= amount;
      }
    }
    return balance;
  }

  double calculateTotalIncome() {
    double income = 0.0;
    for (var transaction in transactions) {
      if (transaction['Category'] == 'income') {
        income += double.parse(transaction['Amount']);
      }
    }
    return income;
  }

  double calculateTotalExpense() {
    double expense = 0.0;
    for (var transaction in transactions) {
      if (transaction['Category'] == 'expense') {
        expense += double.parse(transaction['Amount']);
      }
    }
    return expense;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext builderContext) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.55,
                    color: Colors.teal,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Scaffold.of(builderContext).openDrawer();
                              },
                              icon: Icon(Icons.menu, color: Colors.white),
                            ),
                            Text(
                              'spendX',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.teal,
                                      title: Text('Logout Confirmation',style: TextStyle(color: Color(0xff99EDC3)),),
                                      content: Text('Are you sure you want to logout your account?',style: TextStyle(color: Colors.white),),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel',style: TextStyle(color: Colors.white),),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            _auth.signOut().then((value) {
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Logout',style: TextStyle(color: Color(0xff99EDC3)),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.logout, color: Colors.white),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff99EDC3),
                              ),
                              width: double.infinity,
                              height: 170,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(flex: 1, child: Text('Current Balance', style: TextStyle(color: Color(0xFF093A04), fontSize: 18),)),
                                        Expanded(child: Text('PKR $currentBalance', style: TextStyle(fontSize: 20, color: Color(0xFF093A04)),)),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      child: Row(
                                        children: [
                                          Expanded(child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Color(0xFF093A04))
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            child: Column(
                                              children: [
                                                Text('Income', style: TextStyle(color: Color(0xFF093A04)),),
                                                Text('PKR $totalIncome', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                          )
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Color(0xFF093A04))
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            child: Column(
                                              children: [
                                                Text('Expense', style: TextStyle(color: Color(0xFF093A04)),),
                                                Text('PKR $totalExpense', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                          )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.35,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 500,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.list, color: Colors.teal,),
                                SizedBox(width: 10,),
                                Text('All Transactions', style: TextStyle(fontSize: 18, color: Colors.teal),),
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: 55,
                            child: Form(
                              child: TextFormField(
                                controller: searchController,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  focusedBorder: InputBorder.none,
                                  fillColor: Colors.teal,
                                  prefixIcon: Icon(Icons.search, color: Colors.white,),
                                  hintText: 'Search',
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
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
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                var transaction = transactions[index];
                                String title_position = transaction['Category Name'];
                                var category = transaction['Category'];
                                var categoryname = transaction['Category Name'];
                                var amount = transaction['Amount'];
                                var date = transaction['Date'];
                                if(searchController.text.isEmpty) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTransactionScreen(details: transaction,icon: category=='income'? Icons.trending_down : Icons.trending_up,),));
                                    },
                                    child: ListTile(
                                        leading: category == 'income' ? Icon(Icons.trending_down,color: Colors.green,) : Icon(Icons.trending_up,color: Colors.red,),
                                        title: Text(categoryname,style: TextStyle(color: Colors.teal),),
                                        subtitle: Text(DateFormat('MMM dd, yyyy').format((date as Timestamp).toDate())),
                                        trailing: category == 'income' ? Text('+ PKR ${amount}',style: TextStyle(fontSize: 15,color: Colors.green),) : Text('- PKR ${amount}',style: TextStyle(fontSize: 15, color: Colors.red),)
                                    ),
                                  );
                                }
                                else if(title_position.toLowerCase().contains(searchController.text)||title_position.toUpperCase().contains(searchController.text)||title_position.contains(searchController.text)) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTransactionScreen(details: transaction,icon: category=='income'? Icons.trending_down : Icons.trending_up,),));
                                    },
                                    child: ListTile(
                                        leading: category == 'income' ? Icon(Icons.trending_down,color: Colors.green,) : Icon(Icons.trending_up,color: Colors.red,),
                                        title: Text(categoryname,style: TextStyle(color: Colors.teal),overflow: TextOverflow.ellipsis,),
                                        subtitle: Text(DateFormat('MMM dd, yyyy').format((date as Timestamp).toDate())),
                                        trailing: category == 'income' ? Text('+ PKR ${amount}',style: TextStyle(fontSize: 15,color: Colors.green),) : Text('- PKR ${amount}',style: TextStyle(fontSize: 15, color: Colors.red),)
                                    ),
                                  );
                                }
                                else {
                                  return Container();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Column(
                  children: [
                    ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xffEDF7F6),
                            width: 4,
                          ),
                          color: Colors.teal,
                        ),
                        child: Hero(
                          tag: 'profile',
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen(),));
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: userData?.imageUrl != null
                                  ? Image.network(userData!.imageUrl,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.teal,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    size: 40,
                                    color: Colors.teal,
                                  );
                                },
                              ).image
                                  : Image.asset('assets/images/pic8.png').image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(userData?.name ?? 'User', style: TextStyle(fontSize: 20,color: Colors.white),)
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home,color: Colors.teal,),
                title: Text('Home',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle_rounded,color: Colors.teal,),
                title: Text('My Profile',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen(),));
                },
              ),
              ListTile(
                leading: Icon(Icons.trending_up,color: Colors.teal,),
                title: Text('Add Expense',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen(),));
                },
              ),
              ListTile(
                leading: Icon(Icons.history,color: Colors.teal,),
                title: Text('Expense History',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseHistoryScreen(totalExpense: totalExpense,transactions: transactions.map((doc) => doc.data() as Map<String, dynamic>).toList(),),));
                },
              ),
              ListTile(
                leading: Icon(Icons.trending_down,color: Colors.teal,),
                title: Text('Add Income',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddIncomeScreen(),));
                },
              ),
              ListTile(
                leading: Icon(Icons.history,color: Colors.teal,),
                title: Text('Income History',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeHistoryScreen(totalIncome: totalIncome,transactions: transactions.map((doc) => doc.data() as Map<String, dynamic>).toList(),),));
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback,color: Colors.teal,),
                title: Text('Feedback',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen(),));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout,color: Colors.teal,),
                title: Text('Logout',style: TextStyle(color: Colors.teal),),
                onTap: () async {
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.teal,
                        title: Text('Logout Confirmation',style: TextStyle(color: Color(0xff99EDC3)),),
                        content: Text('Are you sure you want to logout your account?',style: TextStyle(color: Colors.white),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',style: TextStyle(color: Colors.white),),
                          ),
                          TextButton(
                            onPressed: () async{
                              _auth.signOut().then((value) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Logout',style: TextStyle(color: Color(0xff99EDC3)),),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
