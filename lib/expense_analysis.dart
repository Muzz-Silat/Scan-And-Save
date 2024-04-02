import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseAnalysisPage extends StatefulWidget {
  @override
  _ExpenseAnalysisPageState createState() => _ExpenseAnalysisPageState();
}

class _ExpenseAnalysisPageState extends State<ExpenseAnalysisPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _predictedExpense = 0.0;
  bool _isLoading = false;

  String getCurrentUserUID() {
    return _auth.currentUser!.uid;
  }

  Future<void> _getPrediction(List<double> expenses) async {
    setState(() {
      _isLoading = true;
    });
    final apiURL =
        "http://192.168.0.125:5000/predict"; // Change to your API URL
    try {
      final response = await http.post(Uri.parse(apiURL),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"expenses": expenses}));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _predictedExpense = responseData['predicted_expense'];
        });
      } else {
        print("Failed to fetch prediction: ${response.body}");
      }
    } catch (e) {
      print("Error making prediction: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<double>> _fetchLast30DaysExpenses() async {
    List<double> expensesList = List.filled(30, 0.0); // Initialize with 0s
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Calculate the start date (30 days ago)
        final DateTime startDate = DateTime.now().subtract(Duration(days: 30));

        // Query to fetch expenses from the last 30 days
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Expenses')
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .orderBy('date')
            .get();

        for (var doc in result.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final Timestamp timestamp = data['date'];
          final DateTime date = timestamp.toDate();
          final int diffDays = DateTime.now().difference(date).inDays;

          if (diffDays < 30) {
            // Assuming there's a field 'amount' in your documents
            final double amount = data['amount'].toDouble();
            expensesList[29 - diffDays] +=
                amount; // Accumulate amounts for days with multiple expenses
          }
        }
      } catch (e) {
        print("Error fetching expenses: $e");
      }
    }
    return expensesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Analysis'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Predicted Expenses for Next Month: \$$_predictedExpense',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final expenses = await _fetchLast30DaysExpenses();
                      _getPrediction(expenses);
                    },
                    child: Text('Analyze Expenses'),
                  ),
                ],
              ),
      ),
    );
  }
}
