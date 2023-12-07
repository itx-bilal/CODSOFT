import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class IncomeHistoryScreen extends StatefulWidget {
  final double totalIncome;
  final List<Map<String, dynamic>> transactions;

  IncomeHistoryScreen({required this.totalIncome, required this.transactions});

  @override
  State<IncomeHistoryScreen> createState() => _IncomeHistoryScreenState();
}

class _IncomeHistoryScreenState extends State<IncomeHistoryScreen> {
  List<Map<String, dynamic>> filteredIncomes = [];
  @override
  void initState() {
    super.initState();
    filteredIncomes = widget.transactions.where((transaction) => transaction['Category'] == 'income').toList();
  }
  List<FlSpot> getIncomeDataPoints(List<Map<String, dynamic>> transactions) {
    List<FlSpot> expenseDataPoints = [];

    double balance = 0.0;
    for (var i = 0; i < transactions.length; i++) {
      double amount = double.parse(transactions[i]['Amount']);
      String category = transactions[i]['Category'];

      if (category == 'expense') {
        balance -= amount;
      } else {
        balance += amount;
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
          'Income History',
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
                          spots: getIncomeDataPoints(widget.transactions),
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
                      filteredIncomes = widget.transactions
                          .where((transaction) =>
                      transaction['Category'] == 'income' &&
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
              itemCount: filteredIncomes.length,
              itemBuilder: (context, index) {
                var transaction = filteredIncomes[index];
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
                      leading: Icon(Icons.trending_down,color: Colors.green,),
                      title: Text(categoryname,style: TextStyle(color: Colors.teal),),
                      subtitle: Text(DateFormat('MMM dd, yyyy').format((date as Timestamp).toDate())),
                      trailing: Text('+ PKR ${amount}',style: TextStyle(color: Colors.green),),
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
