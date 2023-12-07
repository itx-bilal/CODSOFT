import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  final double totalExpense;
  final List<Map<String, dynamic>> transactions;

  ExpenseHistoryScreen({required this.totalExpense, required this.transactions});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  List<Map<String, dynamic>> filteredExpenses = [];
  @override
  void initState() {
    super.initState();
    filteredExpenses = widget.transactions.where((transaction) => transaction['Category'] == 'expense').toList();
  }
  List<FlSpot> getExpenseDataPoints(List<Map<String, dynamic>> transactions) {
    List<FlSpot> expenseDataPoints = [];

    double balance = 0.0;
    for (var i = 0; i < transactions.length; i++) {
      double amount = double.parse(transactions[i]['Amount']);
      String category = transactions[i]['Category'];

      if (category == 'income') {
        balance += amount;
      } else {
        balance -= amount;
      }
      expenseDataPoints.add(FlSpot(i.toDouble(), balance));
    }
    return expenseDataPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99EDC3),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text(
          'Expense History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          Container(
            width: double.infinity,
            height: 180,
            child: Card(
              elevation: 12,
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                        show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.white,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: getExpenseDataPoints(widget.transactions),
                        isCurved: true,
                        color: Colors.white,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Color(0xff99EDC3),
              width: double.infinity,
              child: Form(
                child: TextFormField(
                  cursorColor: Colors.teal,
                  style: TextStyle(color: Colors.teal),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xffEDF7F6),
                    prefixIcon: Icon(Icons.search,color: Colors.teal,),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredExpenses = widget.transactions
                          .where((transaction) =>
                      transaction['Category'] == 'expense' &&
                          transaction['Category Name']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                var transaction = filteredExpenses[index];
                var category = transaction['Category'];
                var categoryname = transaction['Category Name'];
                var amount = transaction['Amount'];
                var date = transaction['Date'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                    ),
                    child: ListTile(
                      leading: Icon(Icons.trending_up,color: Colors.red,),
                      title: Text(categoryname,style: TextStyle(color: Colors.teal),),
                      subtitle: Text(DateFormat('MMM dd, yyyy').format((date as Timestamp).toDate())),
                      trailing: Text('- PKR ${amount}',style: TextStyle(color: Colors.red),),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
