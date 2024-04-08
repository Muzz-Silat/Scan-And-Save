// // ignore_for_file: prefer_const_constructors, file_names, unnecessary_import, unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_print, must_be_immutable

// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:demo_flutter/mainPages/transactionsPage.dart';
// import 'package:demo_flutter/mainPages/upcomingTransactionsPage.dart';

// import '../lists.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(children: [
//       ListView(
//         physics: AlwaysScrollableScrollPhysics(),
//         padding: EdgeInsets.zero,
//         scrollDirection: Axis.vertical,
//         shrinkWrap: false,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage('assets/background.png'))),
//             child: Column(children: [
//               Padding(
//                   padding: EdgeInsets.fromLTRB(30, 60, 20, 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     // ignore: prefer_const_literals_to_create_immutables
//                     children: [
//                       CircleAvatar(
//                         minRadius: 25,
//                         backgroundImage: AssetImage('assets/profileImage.webp'),
//                       ),
//                       ElevatedButton(
//                         onPressed: (() => {}),
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.white)),
//                         child: Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Payday in a week",
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.greenAccent),
//                             )),
//                       )
//                     ],
//                   )),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: const [
//                   Padding(
//                     padding: EdgeInsets.only(left: 30, bottom: 20, top: 15),
//                     child: Column(
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: [
//                         Text(
//                           "Total Balance To Spend",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           "€5785.55",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 35,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               )
//             ]),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Planning Ahead",
//                   style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 Row(
//                   // ignore: prefer_const_literals_to_create_immutables
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: ((context) => TransactionPage())));
//                       },
//                       child: Text(
//                         "-€540.26",
//                         style: TextStyle(
//                             color: Colors.grey[700],
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 12,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 15),
//             child: SizedBox(
//               height: 120,
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: upcomingTransactions.length,
//                   itemBuilder: (context, int index) {
//                     return SizedBox(
//                       height: 50,
//                       width: 120,
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 0.5,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 upcomingTransactions[index][0],
//                                 Text(
//                                   upcomingTransactions[index][1],
//                                   style: TextStyle(
//                                       color: Colors.greenAccent,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   "In ${upcomingTransactions[index][2].difference(DateTime.now()).inDays.toString()} days",
//                                   style: TextStyle(
//                                       color: Colors.grey[500],
//                                       fontStyle: FontStyle.italic),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Last Week's Expenses",
//                   style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 Row(
//                   // ignore: prefer_const_literals_to_create_immutables
//                   children: [
//                     Text(
//                       "-1592.13",
//                       style: TextStyle(
//                           color: Colors.grey[700], fontWeight: FontWeight.w500),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 12,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           CalendarWeeklyView()
//         ],
//       ),
//     ]));
//   }
// }

// class CalendarWeeklyView extends StatefulWidget {
//   CalendarWeeklyView();

//   @override
//   State<CalendarWeeklyView> createState() => _CalendarWeeklyViewState();
// }

// class _CalendarWeeklyViewState extends State<CalendarWeeklyView> {
//   int? groupValue = 0;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     DateTime today = DateTime.fromMicrosecondsSinceEpoch(
//         DateTime.now().microsecondsSinceEpoch);

//     Widget buildSegment(
//         String dateAbr, String datenumber, BuildContext context) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.075,
//         width: MediaQuery.of(context).size.width * 0.9,
//         child:
//             Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//           Text(
//             dateAbr[0] + dateAbr[1].toUpperCase(),
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Text(datenumber, style: TextStyle(fontSize: 14)),
//         ]),
//       );
//     }

//     DateTime _now = DateTime.now();

//     List<DateTime> dates = [
//       _now,
//       _now.subtract(const Duration(days: 8)),
//       _now.subtract(const Duration(days: 7)),
//       _now.subtract(const Duration(days: 6)),
//       _now.subtract(const Duration(days: 5)),
//       _now.subtract(const Duration(days: 4)),
//       _now.subtract(const Duration(days: 3))
//     ];

//     DateTime _start = DateTime(dates[groupValue!.toInt()].year,
//         dates[groupValue!.toInt()].month, dates[groupValue!.toInt()].day, 0, 0);
//     DateTime _end = DateTime(
//         dates[groupValue!.toInt()].year,
//         dates[groupValue!.toInt()].month,
//         dates[groupValue!.toInt()].day,
//         23,
//         59,
//         59);

//     Widget calendarBox(BuildContext context) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.1,
//         width: MediaQuery.of(context).size.width * 0.9,
//         child: Container(
//             alignment: Alignment.center,
//             child: CupertinoSlidingSegmentedControl<int>(
//                 backgroundColor: Colors.transparent,
//                 thumbColor: Colors.greenAccent,
//                 padding: const EdgeInsets.all(5),
//                 groupValue: groupValue,
//                 children: {
//                   0: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 8)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 8)))
//                           .toString(),
//                       context),
//                   1: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 7)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 7)))
//                           .toString(),
//                       context),
//                   2: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 6)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 6)))
//                           .toString(),
//                       context),
//                   3: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 5)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 5)))
//                           .toString(),
//                       context),
//                   4: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 4)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 4)))
//                           .toString(),
//                       context),
//                   5: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 3)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 3)))
//                           .toString(),
//                       context),
//                   6: buildSegment(
//                       DateFormat.EEEE()
//                           .format(today.subtract(const Duration(days: 2)))
//                           .toString(),
//                       DateFormat.d()
//                           .format(today.subtract(const Duration(days: 2)))
//                           .toString(),
//                       context),
//                 },
//                 onValueChanged: (value) {
//                   setState(() {
//                     groupValue = value;
//                     print(groupValue);
//                   });
//                 })),
//       );
//     }

//     return Column(
//       children: [
//         calendarBox(context),
//         VerticalList(date: dates[groupValue!.toInt()])
//       ],
//     );
//   }
// }

// class VerticalList extends StatefulWidget {
//   VerticalList({required this.date});
//   late DateTime date;

//   @override
//   State<VerticalList> createState() => _VerticalListState();
// }

// class _VerticalListState extends State<VerticalList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.only(top: 5),
//         shrinkWrap: true,
//         scrollDirection: Axis.vertical,
//         itemCount: pastTransactions.length,
//         itemBuilder: (context, int index) {
//           return SizedBox(
//             width: MediaQuery.of(context).size.width * 0.9,
//             child: ListTile(
//               shape: RoundedRectangleBorder(
//                 side: const BorderSide(color: Colors.greenAccent, width: 0.25),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               leading: pastTransactions[index][0],
//               title: Text(
//                 pastTransactions[index][1],
//                 style: TextStyle(color: Colors.greenAccent),
//               ),
//               subtitle: Text(pastTransactions[index][3]),
//               trailing: Text(DateFormat.MMMMEEEEd()
//                   .format(pastTransactions[index][2])
//                   .toString()),
//             ),
//           );
//         });
//   }
// }
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_flutter/mainPages/transactionsPage.dart';
import 'package:demo_flutter/mainPages/SmartBudgetPage.dart';
import 'package:demo_flutter/expense_overview_page.dart';
import 'package:demo_flutter/currency_conversion.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String preferredCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  late DateTime _firstDayOfWeek;
  late DateTime _lastDayOfWeek;
  double monthlyIncome = 0.0;
  double totalBudget = 0.0;
  double totalExpenses = 0.0;
  double currentBudget = 0.0;
  double leftover = 0.0;
  Completer<void> _dataFetchCompleter = Completer<void>();
  Future<void>? _dataFetchFuture;
  CurrencyService currencyService = CurrencyService();

  @override
  void initState() {
    super.initState();
    _updateWeekRange();
    _selectedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    _loadUserPreferences();
    _fetchDataAndComplete();
    fetchFinancialData();
    checkAndRefreshBudget();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFinancialData(); // Fetch on subsequent builds
  }

  void _fetchDataAndComplete() async {
    await fetchFinancialData();
    if (!_dataFetchCompleter.isCompleted) {
      _dataFetchCompleter.complete();
    }
    _dataFetchFuture = _dataFetchCompleter.future;
  }

  String getCurrentMonthYear() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  Future<void> fetchFinancialData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Fetch profile to get the preferred currency, monthly income, and savings
    final profileRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Profile')
        .doc('personal');

    final profileSnapshot = await profileRef.get();
    if (profileSnapshot.exists) {
      preferredCurrency = profileSnapshot.data()?['preferredCurrency'] ?? 'USD';
      monthlyIncome =
          (profileSnapshot.data()?['MonthlyIncome'] as num).toDouble();
    }

    // Fetch the current month's budget from the "Budgets" collection
    String monthYear =
        getCurrentMonthYear(); // Utility function to get the format "Year-Month"
    final budgetRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Budgets')
        .doc(monthYear);

    final budgetSnapshot = await budgetRef.get();
    if (budgetSnapshot.exists) {
      totalBudget =
          (budgetSnapshot.data()?['InitialTotalBudget'] as num).toDouble();
      currentBudget =
          (budgetSnapshot.data()?['CurrentTotalBudget'] as num).toDouble();
    }

    // Fetch and calculate totalExpenses and leftover
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date', isGreaterThanOrEqualTo: DateTime(year, month, 1))
        .where('date', isLessThan: DateTime(year, month + 1, 1))
        .get()
        .then((snapshot) {
      totalExpenses = snapshot.docs.fold(
          0.0, (sum, doc) => sum + (doc.data()['amount'] as num).toDouble());
    });

    leftover = currentBudget - totalExpenses;
    print('Monthly Income: $monthlyIncome');
    print('Initial Total Budget: $totalBudget');
    print('Current Budget: $currentBudget');
    print('Total Expenses: $totalExpenses');
    print('Leftover: $leftover');

    // Ensure you call setState to update the UI if needed
    setState(() {
      this.currentBudget = currentBudget;
      this.totalExpenses = totalExpenses;
      this.leftover = leftover;
    });
  }

  void _updateWeekRange() {
    _firstDayOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    _lastDayOfWeek = _firstDayOfWeek.add(Duration(days: 6));
  }

  void _loadUserPreferences() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Preferences')
          .doc('Settings')
          .get();

      if (prefs.exists) {
        setState(() {
          preferredCurrency = prefs.data()?['preferredCurrency'] ?? 'USD';
        });
      }
    }
  }

  Stream<QuerySnapshot> _getWeeklyExpenses() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }

    // Ensure _firstDayOfWeek and _lastDayOfWeek cover the whole days
    DateTime startOfDay =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    DateTime endOfDay = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots();
  }

  double _calculateTotalExpenses(List<QueryDocumentSnapshot> docs) {
    return docs.fold(0, (total, doc) {
      final expense = doc.data() as Map<String, dynamic>;
      return total + (expense['amount'] as double? ?? 0);
    });
  }

  int calculateInitialIndex() {
    DateTime now = DateTime.now();
    int weekdayIndex =
        now.weekday - 1; // Monday is 1 in DateTime, but we need 0-index
    return weekdayIndex;
  }

  Future<void> checkAndRefreshBudget() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not logged in.");
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final currentMonthYear =
        "${now.year}-${now.month.toString().padLeft(2, '0')}";

    // Attempt to retrieve the current month's budget.
    final currentBudgetDoc = await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Budgets')
        .doc(currentMonthYear)
        .get();

    if (!currentBudgetDoc.exists) {
      // If the current month's budget doesn't exist, fetch the previous month's budget.
      final previousMonthYear = now.month == 1
          ? "${now.year - 1}-12"
          : "${now.year}-${(now.month - 1).toString().padLeft(2, '0')}";

      final previousBudgetDoc = await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Budgets')
          .doc(previousMonthYear)
          .get();

      Map<String, dynamic> newBudgetData;
      if (previousBudgetDoc.exists) {
        // Use the previous month's budget as a template for the current month.
        // This includes copying both the initial allocations/budget and setting them as the current state.
        Map<String, dynamic> previousData = previousBudgetDoc.data()!;
        newBudgetData = {
          'InitialAllocations': Map<String, dynamic>.from(
              previousData['InitialAllocations'] ?? {}),
          'InitialTotalBudget': previousData['InitialTotalBudget'] ?? 0.0,
          'CurrentAllocations': Map<String, dynamic>.from(
              previousData['InitialAllocations'] ?? {}),
          'CurrentTotalBudget': previousData['InitialTotalBudget'] ?? 0.0,
        };
      } else {
        // If there's no previous month's budget, use default values for both initial and current states.
        newBudgetData = {
          'InitialAllocations': {},
          'InitialTotalBudget': 0.0,
          'CurrentAllocations': {},
          'CurrentTotalBudget': 0.0,
        };
      }

      // Create the current month's budget with either the previous month's data or default values.
      await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Budgets')
          .doc(currentMonthYear)
          .set(newBudgetData);
      print(
          'Budget for $currentMonthYear created with initial and current allocations/budgets: $newBudgetData');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, IconData> categoryIcons = {
      'Groceries': Icons.shopping_cart,
      'Dining Out': Icons.restaurant,
      'Transport': Icons.directions_car,
      'Entertainment': Icons.movie,
      'Travel': Icons.airplanemode_active,
      'Education': Icons.school,
      'Clothing & Accessories': Icons.checkroom,
      'Miscellaneous': Icons.miscellaneous_services,
    };
    return Scaffold(
      body: FutureBuilder(
          future: _dataFetchFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Data is still being loaded
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // An error occurred
              return Center(child: Text('An error occurred fetching data'));
            }
            // Data is loaded
            return Stack(
              children: [
                ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  children: [
                    budgetOverview(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ExpenseOverviewPage()),
                                );
                              },
                              child: Container(
                                width: 150,
                                height: 65,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF06767),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(
                                        children: [
                                          Icon(Icons.monetization_on,
                                              color: Colors.black),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 80,
                                      height: 60,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          'Expense Overview',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'CourierPrime',
                                            fontWeight: FontWeight.bold,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SmartBudgetPage()),
                                );
                              },
                              child: Container(
                                width: 150,
                                height: 65,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Color(0xFF35B1EF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(
                                        children: [
                                          Icon(Icons.trending_up,
                                              color: Colors.black),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 75,
                                      height: 60,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          'Set Budget',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'CourierPrime',
                                            fontWeight: FontWeight.bold,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          _getWeeklyExpenses(), // Make sure this function is defined to fetch last week's expenses
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        double totalLastWeek =
                            snapshot.data!.docs.fold(0, (previousValue, doc) {
                          Map<String, dynamic> expense =
                              doc.data() as Map<String, dynamic>;
                          return previousValue + (expense['amount'] as num);
                        });
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const PastTransactionsPage(
                                      showLeading: true,
                                    )));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "CourierPrime",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "View All",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "CourierPrime",
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    CalendarWeeklyView(
                      onDateSelected: (selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                          _updateWeekRange(); // Recalculate weekly range
                        });
                      },
                      initialSelectedIndex:
                          calculateInitialIndex(), // Pass the initial index
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _getWeeklyExpenses(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        // Filter expenses for the selected day
                        var expenses = snapshot.data!.docs.where((doc) {
                          DateTime date = (doc['date'] as Timestamp).toDate();
                          return date.year == _selectedDate.year &&
                              date.month == _selectedDate.month &&
                              date.day == _selectedDate.day;
                        }).toList();

                        if (expenses.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No expenses found for this day.',
                              style: TextStyle(
                                  fontFamily: "CourierPrime",
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            var expense =
                                expenses[index].data() as Map<String, dynamic>;
                            DateTime date =
                                (expense['date'] as Timestamp).toDate();
                            String category = expense['category'];
                            double amount = expense['amount'];
                            String currency = expense['currency'];
                            IconData icon = categoryIcons[category] ??
                                Icons
                                    .help_outline; // Default icon if the category is not found

                            // Use the currency field to determine the correct currency symbol
                            final format =
                                NumberFormat.simpleCurrency(name: currency);
                            String formattedAmount = format.format(
                                amount); // Format the amount with the currency symbol
                            return ListTile(
                              leading: Icon(icon,
                                  size: 40, color: Colors.greenAccent),
                              title: Text(
                                expense['description'],
                                style: TextStyle(
                                    fontFamily: "CourierPrime",
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                formattedAmount,
                                style: TextStyle(
                                    fontFamily: "CourierPrime",
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                DateFormat.MMMMEEEEd().format(date),
                                style: TextStyle(
                                    fontFamily: "CourierPrime",
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  // Widget budgetOverview() {
  //   double budgetToTotalRatio =
  //       totalBudget > 0 ? currentBudget / totalBudget : 0;
  //   double expensesToTotalRatio =
  //       totalBudget > 0 ? totalExpenses / totalBudget : 0;
  //   double leftoverRatio = totalBudget > 0 ? leftover / totalBudget : 0;
  //   String balanceText = '\$${leftover.toStringAsFixed(2)}';

  //   print('Budget to Total Ratio: $budgetToTotalRatio');
  //   print('Expenses to Total Ratio: $expensesToTotalRatio');
  //   print('Leftover Ratio: $leftoverRatio');

  //   return Container(
  //     width: 310,
  //     height: 338,
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
  //     decoration: BoxDecoration(
  //       color: Color(0xFF222121),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         CustomPaint(
  //           size: Size(200, 200), // Adjust the size as needed
  //           painter: ProgressMeterPainter(
  //             budgetRatio: budgetToTotalRatio,
  //             expensesRatio: expensesToTotalRatio,
  //             leftoverRatio: leftoverRatio,
  //             balanceText: balanceText,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget budgetOverview() {
    DateTime now = DateTime.now();
    String monthYear = "${DateFormat.MMMM().format(now)} ${now.year}";
    double budgetToTotalRatio = totalBudget > 0 ? totalBudget / totalBudget : 0;
    double expensesToTotalRatio =
        totalBudget > 0 ? totalExpenses / totalBudget : 0;
    double leftoverRatio = totalBudget > 0 ? leftover / totalBudget : 0;
    String balanceText = '\$${leftover.toStringAsFixed(2)}';

    return Container(
      width: 310,
      height: 425, // Increased height to accommodate additional elements
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Color(0xFF222121),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(monthYear,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "CourierPrime")), // Month and Year
          SizedBox(height: 100),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 200), // Updated size
            painter: ProgressMeterPainter(
              budgetRatio: budgetToTotalRatio,
              expensesRatio: expensesToTotalRatio,
              leftoverRatio: leftoverRatio,
              totalBudget: totalBudget,
              totalExpenses: totalExpenses,
              leftover: leftover,
              balanceText: balanceText,
            ),
          ),
        ],
      ),
    );
  }

// Helper method to build a power bar for budget, expenses, and leftover
  Widget buildPowerBar(String label, double ratio, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        Container(
          width: 100 * ratio, // Assuming max width of 100 for simplicity
          height: 10,
          color: label == "Budget"
              ? Color.fromARGB(255, 103, 240, 173)
              : label == "Expenses"
                  ? Color.fromARGB(255, 240, 103, 103)
                  : Color.fromARGB(255, 183, 186, 42),
        ),
        Text('\$${value.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

// class ProgressMeterPainter extends CustomPainter {
//   final double budgetRatio;
//   final double expensesRatio;
//   final double leftoverRatio;
//   final String balanceText;

//   ProgressMeterPainter({
//     required this.budgetRatio,
//     required this.expensesRatio,
//     required this.leftoverRatio,
//     required this.balanceText,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     double strokeWidth = 12;
//     double startAngle = -math.pi / 2;
//     Offset center = Offset(size.width / 2, size.height / 2);
//     double radius = size.width / 2;

//     // Adjust each Paint object to have rounded stroke caps
//     final Paint budgetPaint = Paint()
//       ..strokeWidth = strokeWidth
//       ..color = Color.fromARGB(255, 103, 240, 173) // Budget color
//       ..strokeCap = StrokeCap.round // Rounded ends
//       ..style = PaintingStyle.stroke;

//     final Paint expensesPaint = Paint()
//       ..strokeWidth = strokeWidth
//       ..color = Color.fromARGB(255, 240, 103, 103) // Expenses color
//       ..strokeCap = StrokeCap.round // Rounded ends
//       ..style = PaintingStyle.stroke;

//     final Paint leftoverPaint = Paint()
//       ..strokeWidth = strokeWidth
//       ..color = Color.fromARGB(255, 183, 186, 42) // Leftover color
//       ..strokeCap = StrokeCap.round // Rounded ends
//       ..style = PaintingStyle.stroke;

//     // Calculate the sweep angles based on ratios
//     double budgetSweep = 2 * math.pi * budgetRatio;
//     double expensesSweep = 2 * math.pi * expensesRatio;
//     double leftoverSweep = 2 * math.pi * leftoverRatio;

//     // Draw the arcs with the updated paint objects
//     canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
//         budgetSweep, false, budgetPaint);
//     canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius - strokeWidth),
//         startAngle,
//         expensesSweep,
//         false,
//         expensesPaint);
//     canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius - 2 * strokeWidth),
//         startAngle,
//         leftoverSweep,
//         false,
//         leftoverPaint);

//     // Drawing the balance text remains unchanged
//     final textSpan = TextSpan(
//       text: balanceText,
//       style: TextStyle(
//           color: Colors.white, fontSize: 24, fontFamily: "CourierPrime"),
//     );
//     final textPainter =
//         TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
//     textPainter.layout(minWidth: 0, maxWidth: size.width);
//     final xCenter = (size.width - textPainter.width) * 0.5;
//     final yCenter = (size.height - textPainter.height) * 0.5;
//     textPainter.paint(canvas, Offset(xCenter, yCenter));
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

class ProgressMeterPainter extends CustomPainter {
  final double budgetRatio;
  final double expensesRatio;
  final double leftoverRatio;
  final double totalBudget;
  final double totalExpenses;
  final double leftover;
  final String balanceText;

  ProgressMeterPainter({
    required this.budgetRatio,
    required this.expensesRatio,
    required this.leftoverRatio,
    required this.totalBudget,
    required this.totalExpenses,
    required this.leftover,
    required this.balanceText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 12;
    final Offset center = Offset(size.width / 2, size.height / 8);
    final double radius = size.width / 3.75; // Smaller radius

    // Draw circular arcs
    _drawCircularArc(canvas, center, radius, strokeWidth, budgetRatio,
        Color.fromARGB(255, 103, 240, 173));
    _drawCircularArc(canvas, center, radius - strokeWidth, strokeWidth,
        expensesRatio, Color.fromARGB(255, 240, 103, 103));
    _drawCircularArc(canvas, center, radius - 2 * strokeWidth, strokeWidth,
        leftoverRatio, Color.fromARGB(255, 183, 186, 42));

    // Draw power bars
    double startY = center.dy + radius + 40; // Start below the circular arcs
    _drawPowerBar(canvas, size, startY, 'Budget', budgetRatio, totalBudget,
        Color.fromARGB(255, 103, 240, 173));
    _drawPowerBar(canvas, size, startY += 30, 'Expenses', expensesRatio,
        totalExpenses, Color.fromARGB(255, 240, 103, 103));
    _drawPowerBar(canvas, size, startY += 30, 'Leftover', leftoverRatio,
        leftover, Color.fromARGB(255, 183, 186, 42));

    // Draw total balance text at the top
    _drawBalanceText(canvas, size, balanceText);
  }

  void _drawCircularArc(Canvas canvas, Offset center, double radius,
      double strokeWidth, double ratio, Color color) {
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double sweepAngle = 2 * math.pi * ratio;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, sweepAngle, false, paint);
  }

  void _drawPowerBar(Canvas canvas, Size size, double y, String label,
      double ratio, double value, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double barHeight = 10;
    final double maxBarWidth = size.width - 160; // Adjust for padding
    final double barWidth = maxBarWidth * ratio;
    final Offset barStart = Offset(80, y); // Starting point of the bar

    // Draw the label
    _drawText(canvas, label, barStart.translate(-80, -8), TextAlign.right);

    // Draw the rounded bar
    RRect bar = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            barStart.dx, barStart.dy - barHeight / 2, barWidth, barHeight),
        Radius.circular(barHeight / 2));
    canvas.drawRRect(bar, paint);

    // Draw the value
    _drawText(canvas, '\$${value.toStringAsFixed(2)}',
        barStart.translate(barWidth + 10, -8), TextAlign.left);
  }

  void _drawText(Canvas canvas, String text, Offset position, TextAlign align) {
    final TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontFamily: "CourierPrime"),
        text: text);
    final TextPainter tp = TextPainter(
        text: span, textAlign: align, textDirection: ui.TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, position);
  }

  void _drawBalanceText(Canvas canvas, Size size, String balanceText) {
    final TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "CourierPrime",
            fontWeight: FontWeight.bold),
        text: 'Total Balance\n$balanceText');
    final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr);
    tp.layout(maxWidth: size.width);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget _buildOverviewCard(String title, String value) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 0.5,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(value,
              style: TextStyle(
                  color: Colors.grey[500], fontStyle: FontStyle.italic)),
        ],
      ),
    ),
  );
}

// Assuming CalendarWeeklyView is a widget that displays the calendar UI
// Make necessary modifications based on your actual CalendarWeeklyView implementation
class CalendarWeeklyView extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final int initialSelectedIndex;

  CalendarWeeklyView(
      {required this.onDateSelected, required this.initialSelectedIndex});

  @override
  State<CalendarWeeklyView> createState() => _CalendarWeeklyViewState();
}

class _CalendarWeeklyViewState extends State<CalendarWeeklyView> {
  late int groupValue;
  List<DateTime> dates = []; // This will hold your dates

  @override
  void initState() {
    super.initState();
    _initDates();
    // Find the index of the current day
    DateTime now = DateTime.now();
    groupValue = dates.indexWhere((date) =>
        date.day == now.day &&
        date.month == now.month &&
        date.year == now.year);
    if (groupValue == -1) {
      // This means today's date was not found in the list (shouldn't happen, but as a fallback)
      groupValue = 0;
    }
    // Call the onDateSelected to ensure the correct date is selected on the parent widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(dates[groupValue]);
    });
  }

  void _initDates() {
    DateTime now = DateTime.now();
    // Initialize dates for the last 7 days, including today
    dates =
        List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
  }

  Widget calendarBox(BuildContext context) {
    // Creating segments for each day
    Map<int, Widget> children = Map.fromIterable(
      Iterable<int>.generate(dates.length),
      key: (item) => item as int,
      value: (item) {
        int index = item as int;
        return buildSegment(
          DateFormat.E().format(dates[index]), // Day abbreviation
          DateFormat.d().format(dates[index]), // Day number
          context,
          index,
        );
      },
    );

    return Container(
      alignment: Alignment.center,
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: Colors.transparent,
        thumbColor: Colors.greenAccent,
        padding: const EdgeInsets.all(5),
        groupValue: groupValue,
        children: children,
        onValueChanged: (value) {
          if (value != null) {
            setState(() {
              groupValue = value;
              widget.onDateSelected(
                  dates[value]); // Notify HomePage about the selection
            });
          }
        },
      ),
    );
  }

  Widget buildSegment(
      String dateAbr, String datenumber, BuildContext context, int index) {
    // Determine if this segment is selected
    bool isSelected = groupValue == index;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.075,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            dateAbr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.white,
                fontFamily: "CourierPrime"),
          ),
          Text(
            datenumber,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.white,
                fontFamily: "CourierPrime"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        calendarBox(context), // This displays the segmented control calendar
      ],
    );
  }
}
