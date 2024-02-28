// ignore_for_file: file_names, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastTransactionsPage extends StatefulWidget {
  const PastTransactionsPage({Key? key}) : super(key: key);

  @override
  State<PastTransactionsPage> createState() => _PastTransactionsPageState();
}

class _PastTransactionsPageState extends State<PastTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          "Past Transactions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: (Container(child: UpcomingTransactionsList())),
    );
  }
}

final Map<String, IconData> categoryIcons = {
  'Food': Icons.fastfood,
  'Transport': Icons.directions_car,
  'Shopping': Icons.shopping_cart,
  // Add more categories and their corresponding icons
};

class UpcomingTransactionsList extends StatefulWidget {
  const UpcomingTransactionsList();

  @override
  State<UpcomingTransactionsList> createState() =>
      _UpcomingTransactionsListState();
}

class _UpcomingTransactionsListState extends State<UpcomingTransactionsList> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("Please login to see transactions."));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Expenses')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var expenses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            var expense = expenses[index].data()
                as Map<String, dynamic>; // Cast the data to a Map
            DateTime date = (expense['date'] as Timestamp).toDate();
            double amount = expense['amount'];
            String description = expense['description'];
            String currency = expense.containsKey('currency')
                ? expense['currency'] as String
                : 'USD'; // Default to USD if missing
            // Provide a default value if the category field is missing
            String category = expense.containsKey('category')
                ? expense['category'] as String
                : 'Uncategorized';

            // Use the currency field to determine the correct currency symbol
            final format = NumberFormat.simpleCurrency(name: currency);
            String formattedAmount = format
                .format(amount); // Format the amount with the currency symbol

            Icon icon = Icon(
              categoryIcons[category] ??
                  Icons.category, // Use a default icon if category is not found
              size: 40,
            );

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                leading: icon,
                title: Text(
                  formattedAmount,
                  style: TextStyle(color: Colors.greenAccent),
                ),
                subtitle: Text(description),
                trailing: Text(DateFormat.MMMMEEEEd().format(date).toString()),
              ),
            );
          },
        );
      },
    );
  }
}
