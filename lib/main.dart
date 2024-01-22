import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_page.dart';
import 'add_expense_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'recommend_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color customColor = const Color.fromARGB(255, 0, 247, 41);
    // MaterialColor customMaterialColor = MaterialColor(
    //   customColor.value,
    //   <int, Color>{
    //     500: customColor, // Only one shade with value 500
    //   },
    // );
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          )),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    AddExpensePage(),
    RecommendPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        color: const Color.fromARGB(255, 0, 247, 41),
        backgroundColor: Colors.black,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_month_rounded, size: 30),
          Icon(Icons.add, size: 30),
          Icon(
            Icons.attach_money_rounded,
            size: 30,
          ),
          Icon(
            Icons.person,
            size: 30,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
