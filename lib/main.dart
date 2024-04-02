// import 'package:flutter/material.dart';
// //import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'home_page.dart';
// import 'add_expense_page.dart';
// import 'history_page.dart';
// import 'profile_page.dart';
// import 'recommend_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
// import 'package:demo_flutter/login_page.dart';
// import 'package:demo_flutter/signup_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//           options: const FirebaseOptions(
//               apiKey: "AIzaSyCcvDoMTL02gZUG5dge75_0ngdYjEFP2_E",
//               appId: "1:790734238609:android:ce3e9d04b06eaace56a030",
//               messagingSenderId: "790734238609",
//               projectId: "expensetracker-81336"))
//       : await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// MaterialColor customDarkGray = MaterialColor(
//   0xFF808080, // Replace with your desired dark gray color hex code
//   <int, Color>{
//     50: Color(0xFF808080),
//     100: Color(0xFF808080),
//     200: Color(0xFF808080),
//     300: Color(0xFF808080),
//     400: Color(0xFF808080),
//     500: Color(0xFF808080),
//     600: Color(0xFF808080),
//     700: Color(0xFF808080),
//     800: Color(0xFF808080),
//     900: Color(0xFF808080),
//   },
// );

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Expense Tracker',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: customDarkGray,
//         scaffoldBackgroundColor: Colors.black,
//         textTheme: TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white),
//         ),

//         // Your theme data remains unchanged
//       ),
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.hasData) {
//               return const MyHomePage(); // User is signed in
//             }
//             return const LoginPage(); // User is not signed in, show login page
//           }
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(), // Loading state
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _currentIndex = 0;

//   // Add the pages here
//   final List<Widget> _pages = [
//     // Replace with your actual pages
//     HomePage(),
//     HistoryPage(),
//     AddExpensePage(),
//     RecommendPage(),
//     ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expense Tracker'),
//       ),
//       body: _pages[_currentIndex],
//       floatingActionButton: _buildAddExpenseButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.grey.shade800, // Darker gray bar color
//         shape: CircularNotchedRectangle(),
//         notchMargin: 6.0,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildNavBarItem(0, Icons.home),
//             _buildNavBarItem(1, Icons.calendar_today),
//             SizedBox(width: 48.0), // Adjust for the FAB width
//             _buildNavBarItem(3, Icons.attach_money),
//             _buildNavBarItem(4, Icons.person),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavBarItem(int index, IconData icon) {
//     return IconButton(
//       iconSize: 30.0, // Adjust icon size
//       icon: Icon(
//         icon,
//         color: _currentIndex == index ? Colors.white : Colors.grey.shade600,
//       ),
//       onPressed: () {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//     );
//   }

//   Widget _buildAddExpenseButton() {
//     return FloatingActionButton(
//       backgroundColor:
//           Colors.grey.shade800, // Change to your desired button color
//       onPressed: () {
//         setState(() {
//           _currentIndex = 2; // Assign the index for the Add Expense page
//         });
//       },
//       child: const Icon(Icons.add),
//       elevation: 2.0,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:demo_flutter/screens/home_screen.dart';
import 'package:demo_flutter/screens/login_screen.dart';
import 'package:demo_flutter/screens/signup_screen.dart';
import 'package:demo_flutter/screens/welcome.dart';
import 'package:demo_flutter/add_expense_page.dart';
import 'package:demo_flutter/mainPages/home_navigation_page.dart';
import 'package:demo_flutter/add_expense_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_bloc.dart';
import 'theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCcvDoMTL02gZUG5dge75_0ngdYjEFP2_E",
              appId: "1:790734238609:android:ce3e9d04b06eaace56a030",
              messagingSenderId: "790734238609",
              projectId: "expensetracker-81336"))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.greenAccent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.greenAccent,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          color: Color.fromARGB(255, 46, 46, 46),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 46, 46, 46),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // User is signed in
            if (snapshot.hasData) {
              return const HomeNavigationPage();
            } else {
              // User is not signed in
              return const HomeScreen();
            }
          }
          // Waiting for authentication to complete
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        HomeNavigationPage.routeName: (context) => const HomeNavigationPage(),
        AddExpensePage.routeName: (context) => const AddExpensePage(),
        '/addExpenseOptions': (context) => AddExpenseOptionsPage(),
        // Add other routes here
      },
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:demo_flutter/screens/home_screen.dart';
// import 'package:demo_flutter/screens/login_screen.dart';
// import 'package:demo_flutter/screens/signup_screen.dart';
// import 'package:demo_flutter/screens/welcome.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'mainPages/AccountPage.dart';
// import 'mainPages/HomePage.dart';
// import 'mainPages/transactionsPage.dart';
// import 'mainPages/upcomingTransactionsPage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//           options: const FirebaseOptions(
//               apiKey: "AIzaSyCcvDoMTL02gZUG5dge75_0ngdYjEFP2_E",
//               appId: "1:790734238609:android:ce3e9d04b06eaace56a030",
//               messagingSenderId: "790734238609",
//               projectId: "expensetracker-81336"))
//       : await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.lightGreen,
//       ),
//       initialRoute: HomeScreen.id, // Set HomeScreen.id as the initial route
//       routes: {
//         HomeScreen.id: (context) => const HomeNavigationPage(
//             0), // Direct to the main app with bottom navigation
//         LoginScreen.id: (context) => const LoginScreen(),
//         SignUpScreen.id: (context) => const SignUpScreen(),
//         '/welcome': (context) =>
//             const WelcomeScreen(), // Additional route for WelcomeScreen if needed
//         // Define other routes as needed
//       },
//     );
//   }
// }

// class HomeNavigationPage extends StatefulWidget {
//   const HomeNavigationPage(this.initialIndex, {Key? key}) : super(key: key);
//   final int initialIndex;

//   @override
//   State<HomeNavigationPage> createState() => _HomeNavigationPageState();
// }

// class _HomeNavigationPageState extends State<HomeNavigationPage> {
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       const HomePage(),
//       const TransactionPage(),
//       const PastTransactionsPage(),
//       const AccountPage(),
//     ];

//     return Scaffold(
//       body: IndexedStack(
//         index: currentIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         unselectedItemColor: Colors.grey,
//         selectedItemColor: Colors.greenAccent,
//         currentIndex: currentIndex,
//         onTap: (index) => setState(() => currentIndex = index),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.money), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.timeline), label: "Upcoming"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
//         ],
//       ),
//     );
//   }
// }
