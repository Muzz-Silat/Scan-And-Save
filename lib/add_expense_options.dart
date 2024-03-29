import 'package:flutter/material.dart';
import 'add_expense_page.dart';
import 'invoice_detection_page.dart';

class AddExpenseOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense Options"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AddExpensePage.routeName);
              },
              child: Text('Manual Expense Adding'),
            ),
            SizedBox(height: 20), // For spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InvoiceDetectionPage()),
                );
              },
              child: Text('Receipt Scanning'),
            ),
          ],
        ),
      ),
    );
  }
}
