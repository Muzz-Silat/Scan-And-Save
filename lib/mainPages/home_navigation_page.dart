import 'package:flutter/material.dart';
import 'HomePage.dart'; // Adjust the import path
import 'TransactionsPage.dart'; // Adjust the import path
import 'UpcomingTransactionsPage.dart';
import 'AccountPage.dart'; // Adjust the import path
import '../add_expense_page.dart'; // Import the AddExpensePage

class HomeNavigationPage extends StatefulWidget {
  static const String routeName = '/homeNavigationPage';
  final int currentIndex;

  const HomeNavigationPage({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomeNavigationPageState createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  late int _currentIndex;

  // List of pages for navigation
  final List<Widget> _screens = [
    const HomePage(),
    const TransactionPage(),
    const PastTransactionsPage(),
    const AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddExpensePage.routeName);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.money),
                    label: 'Transactions',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Past',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                  ),
                ],
                currentIndex: _currentIndex,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.greenAccent,
                onTap: _onItemTapped,
                type: BottomNavigationBarType
                    .fixed, // This ensures that all items are fixed and evenly spaced
                backgroundColor: Colors
                    .transparent, // Makes BottomNavigationBar background transparent
                elevation: 0, // Removes shadow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
