// ignore_for_file: prefer_const_constructors, file_names

import 'package:demo_flutter/expense_analysis.dart';
import 'package:demo_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_flutter/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_flutter/theme_bloc.dart';
import 'package:demo_flutter/theme_event.dart';
import 'package:demo_flutter/theme_state.dart';
import 'package:demo_flutter/screens/login_screen.dart';
import 'package:demo_flutter/settings_page.dart';
import 'package:demo_flutter/saved_receipts.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _auth = FirebaseAuth.instance;
  String _income = '\$0.00';
  String _budget = '\$0.00';
  String _savings = '\$0.00';
  String? _profilePicUrl;
  String _name = '';

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  @override
  void initState() {
    super.initState();
    _fetchFinancialOverview();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Profile')
          .doc('personal')
          .get();
      if (userProfile.exists) {
        Map<String, dynamic> userData =
            userProfile.data() as Map<String, dynamic>;
        setState(() {
          _profilePicUrl = userData['ProfilePicture'];
          _name = userData['Name'] ?? '';
        });
      }
    }
  }

  Future<void> _fetchFinancialOverview() async {
    final user = _auth.currentUser;
    if (user != null) {
      final profileDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Profile')
          .doc('personal')
          .get();

      if (profileDoc.exists) {
        final data = profileDoc.data();
        setState(() {
          _income = '\$${data?['MonthlyIncome'].toStringAsFixed(2)}';
          _savings = '\$${data?['Savings'].toStringAsFixed(2)}';
        });
      }

      final currentMonthYear = DateFormat('yyyy-MM').format(DateTime.now());
      final budgetDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Budgets')
          .doc(currentMonthYear)
          .get();

      if (budgetDoc.exists) {
        final data = budgetDoc.data();
        setState(() {
          _budget = '\$${data?['CurrentTotalBudget'].toStringAsFixed(2)}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "CourierPrime",
              fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 0, 6.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 24, 24, 24),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.logout),
                      color: Color.fromARGB(255, 103, 240, 173),
                      onPressed: _logout,
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profilePicUrl != null
                        ? NetworkImage(_profilePicUrl!)
                        : NetworkImage('https://via.placeholder.com/150'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _name.isNotEmpty ? _name : "Username",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CourierPrime',
                    ),
                  ),
                  SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoBox('Income', _income),
                        _buildInfoBox('Budget', _budget),
                        _buildInfoBox('Savings', _savings),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24), // Adds a space between the boxes
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              child: Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: Color.fromARGB(255, 103, 240, 173),
                      size: 28,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CourierPrime',
                      ),
                    ),
                    Spacer(), // Pushes the arrow icon to the far right
                    Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 103, 240, 173),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReceiptsPage()));
              },
              child: Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.library_books,
                      color: Color.fromARGB(255, 103, 240, 173),
                      size: 28,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Saved Receipts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CourierPrime',
                      ),
                    ),
                    Spacer(), // Pushes the arrow icon to the far right
                    Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 103, 240, 173),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ExpenseAnalysisPage()));
              },
              child: Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: Color.fromARGB(255, 103, 240, 173),
                      size: 28,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Expense Prediction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CourierPrime',
                      ),
                    ),
                    Spacer(), // Pushes the arrow icon to the far right
                    Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 103, 240, 173),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100, // Adjust the width as needed
          height: 60, // Adjust the height as needed
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 35, 35, 35),
            borderRadius: BorderRadius.circular(13),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'CourierPrime',
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'CourierPrime',
          ),
        ),
      ],
    );
  }
}
