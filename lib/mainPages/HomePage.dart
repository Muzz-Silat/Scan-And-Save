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
import 'dart:ui';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _preferredCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  late DateTime _firstDayOfWeek;
  late DateTime _lastDayOfWeek;
  double monthlyIncome = 0.0;
  double totalBudget = 0.0;
  double totalExpenses = 0.0;
  double leftover = 0.0;
  Completer<void> _dataFetchCompleter = Completer<void>();
  Future<void>? _dataFetchFuture;

  @override
  void initState() {
    super.initState();
    _updateWeekRange();
    _loadUserPreferences();
    _fetchDataAndComplete();
  }

  void _fetchDataAndComplete() async {
    await fetchFinancialData();
    if (!_dataFetchCompleter.isCompleted) {
      _dataFetchCompleter.complete();
    }
    _dataFetchFuture = _dataFetchCompleter.future;
  }

  Future<void> fetchFinancialData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Fetch monthly income and total budget
    final userRef =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    DocumentSnapshot userSnapshot = await userRef.get();
    monthlyIncome = userSnapshot.get('totalBudget').toDouble() ?? 0.0;
    // Calculate total expenses for the current month
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
      totalExpenses = snapshot.docs
          .fold(0.0, (sum, doc) => sum + (doc['amount'] as double));
    });
    // Calculate leftover
    leftover = monthlyIncome - totalExpenses;

    setState(() {});
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
          _preferredCurrency = prefs.data()?['PreferredCurrency'] ?? 'USD';
        });
      }
    }
  }

  Stream<QuerySnapshot> _getWeeklyExpenses() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(_firstDayOfWeek))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(_lastDayOfWeek))
        .snapshots();
  }

  double _calculateTotalExpenses(List<QueryDocumentSnapshot> docs) {
    return docs.fold(0, (total, doc) {
      final expense = doc.data() as Map<String, dynamic>;
      return total + (expense['amount'] as double? ?? 0);
    });
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Expense Overview",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      ExpenseOverviewPage())));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "See more",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
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

                        final format = NumberFormat.currency(
                            locale: 'en_US',
                            symbol: '\$'); // Adjust locale and symbol as needed
                        String formattedTotalLastWeek =
                            format.format(totalLastWeek);

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const PastTransactionsPage())); // Adjust as needed
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Last Week's Expenses",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formattedTotalLastWeek,
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 12),
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
                          _updateWeekRange(); // Update the week range based on the newly selected date
                        });
                      },
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
                            child: Text('No expenses found for this day.'),
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
                              title: Text(expense['description']),
                              subtitle: Text(formattedAmount),
                              trailing:
                                  Text(DateFormat.MMMMEEEEd().format(date)),
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

  Widget budgetOverview() {
    // return Column(
    //   children: [
    //     Container(
    //       width: 310,
    //       height: 338,
    //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    //       decoration: BoxDecoration(
    //         color: Color(0xFF222121),
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       child: Column(
    //         children: [
    //           Text(
    //             'Total Balance',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //             ),
    //           ),
    //           Text(
    //             '\$${leftover.toStringAsFixed(2)}',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 24,
    //             ),
    //           ),
    //           SizedBox(height: 10),
    //           Text(
    //             'Income',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //             ),
    //           ),
    //           Text(
    //             '\$${monthlyIncome.toStringAsFixed(2)}',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 24,
    //             ),
    //           ),
    //           SizedBox(height: 10),
    //           Text(
    //             'Expenses',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //             ),
    //           ),
    //           Text(
    //             '\$${totalExpenses.toStringAsFixed(2)}',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 24,
    //             ),
    //           ),
    //           SizedBox(height: 10),
    //           Text(
    //             'Leftover',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //             ),
    //           ),
    //           Text(
    //             '\$${leftover.toStringAsFixed(2)}',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 24,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );

    // UI attempt 1
    // return Column(
    //   children: [
    //     Container(
    //       width: 130,
    //       height: 400,
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Container(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    //             clipBehavior: Clip.antiAlias,
    //             decoration: ShapeDecoration(
    //               color: Color(0xFF222121),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(16),
    //               ),
    //             ),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Container(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Container(
    //                         padding: const EdgeInsets.symmetric(
    //                             horizontal: 5, vertical: 3),
    //                         clipBehavior: Clip.antiAlias,
    //                         decoration: ShapeDecoration(
    //                           color: Color(0xFF67F0AD),
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(90.50),
    //                           ),
    //                         ),
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Container(
    //                               width: 95,
    //                               height: 95,
    //                               decoration: ShapeDecoration(
    //                                 color: Color(0xFFF06767),
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(87),
    //                                 ),
    //                               ),
    //                             ),
    //                             const SizedBox(width: 10),
    //                             Container(
    //                               width: 80,
    //                               height: 80,
    //                               decoration: ShapeDecoration(
    //                                 color: Color(0xFFB7BA2A),
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius:
    //                                       BorderRadius.circular(81.50),
    //                                 ),
    //                               ),
    //                             ),
    //                             const SizedBox(width: 10),
    //                             Container(
    //                               width: 60,
    //                               height: 75,
    //                               decoration: ShapeDecoration(
    //                                 color: Color(0xFF2E2E2E),
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(76),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       const SizedBox(height: 10),
    //                       Container(
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: [
    //                             SizedBox(
    //                               width: 79,
    //                               height: 8,
    //                               child: Text(
    //                                 'Total Balance',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 10,
    //                                   fontFamily: 'Cutive Mono',
    //                                   fontWeight: FontWeight.w400,
    //                                   height: 0,
    //                                 ),
    //                               ),
    //                             ),
    //                             Text(
    //                               '\$2,786.05',
    //                               textAlign: TextAlign.center,
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontSize: 24,
    //                                 fontFamily: 'Dangrek',
    //                                 fontWeight: FontWeight.w400,
    //                                 height: 0,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(height: 27),
    //                 Container(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Container(
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.end,
    //                           children: [
    //                             Container(
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.center,
    //                                 children: [
    //                                   Text(
    //                                     'Income',
    //                                     textAlign: TextAlign.center,
    //                                     style: TextStyle(
    //                                       color: Colors.white,
    //                                       fontSize: 10,
    //                                       fontFamily: 'Cutive Mono',
    //                                       fontWeight: FontWeight.w400,
    //                                       height: 0,
    //                                     ),
    //                                   ),
    //                                   const SizedBox(width: 14),
    //                                   Container(
    //                                     width: 50,
    //                                     height: 5,
    //                                     decoration: ShapeDecoration(
    //                                       color: Color(0xFF67F0AD),
    //                                       shape: RoundedRectangleBorder(
    //                                         borderRadius:
    //                                             BorderRadius.circular(50),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                             const SizedBox(width: 6),
    //                             SizedBox(
    //                               width: 50,
    //                               height: 9,
    //                               child: Text(
    //                                 '\$3000.00',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 10,
    //                                   fontFamily: 'Cutive Mono',
    //                                   fontWeight: FontWeight.w400,
    //                                   height: 0,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       const SizedBox(height: 7),
    //                       Container(
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: [
    //                             Container(
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.center,
    //                                 children: [
    //                                   Text(
    //                                     'Expenses',
    //                                     textAlign: TextAlign.center,
    //                                     style: TextStyle(
    //                                       color: Colors.white,
    //                                       fontSize: 10,
    //                                       fontFamily: 'Cutive Mono',
    //                                       fontWeight: FontWeight.w400,
    //                                       height: 0,
    //                                     ),
    //                                   ),
    //                                   const SizedBox(width: 8),
    //                                   Container(
    //                                     width: 34,
    //                                     height: 5,
    //                                     decoration: ShapeDecoration(
    //                                       color: Color(0xFFF06767),
    //                                       shape: RoundedRectangleBorder(
    //                                         borderRadius:
    //                                             BorderRadius.circular(50),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                             const SizedBox(width: 137),
    //                             SizedBox(
    //                               width: 50,
    //                               height: 9,
    //                               child: Text(
    //                                 '\$213.95',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 10,
    //                                   fontFamily: 'Cutive Mono',
    //                                   fontWeight: FontWeight.w400,
    //                                   height: 0,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       const SizedBox(height: 7),
    //                       Container(
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: [
    //                             Container(
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.center,
    //                                 children: [
    //                                   Text(
    //                                     'Leftover',
    //                                     textAlign: TextAlign.center,
    //                                     style: TextStyle(
    //                                       color: Colors.white,
    //                                       fontSize: 10,
    //                                       fontFamily: 'Cutive Mono',
    //                                       fontWeight: FontWeight.w400,
    //                                       height: 0,
    //                                     ),
    //                                   ),
    //                                   const SizedBox(width: 8),
    //                                   Container(
    //                                     width: 131,
    //                                     height: 5,
    //                                     decoration: ShapeDecoration(
    //                                       color: Color(0xFFB7BA2A),
    //                                       shape: RoundedRectangleBorder(
    //                                         borderRadius:
    //                                             BorderRadius.circular(50),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                             const SizedBox(width: 42),
    //                             SizedBox(
    //                               width: 52,
    //                               height: 9,
    //                               child: Text(
    //                                 '\$2786.05',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 10,
    //                                   fontFamily: 'Cutive Mono',
    //                                   fontWeight: FontWeight.w400,
    //                                   height: 0,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(width: 31),
    //           Container(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
    //             clipBehavior: Clip.antiAlias,
    //             decoration: ShapeDecoration(
    //               color: Color(0xFF35B1EF),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(27),
    //               ),
    //             ),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   width: 101,
    //                   height: 40,
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Container(
    //                         padding: const EdgeInsets.all(10),
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Container(
    //                               padding: const EdgeInsets.all(2),
    //                               clipBehavior: Clip.antiAlias,
    //                               decoration: BoxDecoration(),
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                   const SizedBox(width: 10),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       Container(
    //                         padding: const EdgeInsets.all(10),
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Container(
    //                               padding: const EdgeInsets.all(10),
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.center,
    //                                 children: [
    //                                   Text(
    //                                     'Set \nBudget',
    //                                     style: TextStyle(
    //                                       color: Colors.black,
    //                                       fontSize: 10,
    //                                       fontFamily: 'Courier Prime',
    //                                       fontWeight: FontWeight.w400,
    //                                       height: 0,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(width: 31),
    //           Container(
    //             width: 141,
    //             height: 54,
    //             child: Stack(
    //               children: [
    //                 Positioned(
    //                   left: 0,
    //                   top: 0,
    //                   child: Container(
    //                     width: 141,
    //                     height: 54,
    //                     decoration: ShapeDecoration(
    //                       color: Color(0xFFF06767),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(27),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   left: 58,
    //                   top: 17,
    //                   child: SizedBox(
    //                     width: 74,
    //                     child: Text(
    //                       'Expenses overview',
    //                       style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 10,
    //                         fontFamily: 'Courier Prime',
    //                         fontWeight: FontWeight.w400,
    //                         height: 0,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   left: 19,
    //                   top: 15,
    //                   child: Container(
    //                     width: 26,
    //                     height: 26,
    //                     clipBehavior: Clip.antiAlias,
    //                     decoration: BoxDecoration(),
    //                     child: Stack(children: []),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );

    //attempt 2
    return Container(
      width: 310,
      height: 338,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Color(0xFF222121),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(200, 200), // You can change the size as needed
            painter: ProgressMeterPainter(
              income: 1500,
              expenses: 300,
              leftover: 1200,
            ),
          ),
          Text(
            'Total Balance',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            '\$"1300"',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          // Add other text fields and styling for Income, Expenses, Leftover
        ],
      ),
    );
  }
}

class ProgressMeterPainter extends CustomPainter {
  final double income;
  final double expenses;
  final double leftover;

  ProgressMeterPainter({
    required this.income,
    required this.expenses,
    required this.leftover,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 15;
    double startAngle = -math.pi / 2;
    double total = income + expenses + leftover;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw income
    final incomePaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Color.fromARGB(255, 103, 240, 173)
      ..style = PaintingStyle.stroke;

    double incomeSweep = 2 * math.pi * (income);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      incomeSweep,
      false,
      incomePaint,
    );

    // Draw expenses
    final expensesPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Color.fromARGB(255, 240, 103, 103)
      ..style = PaintingStyle.stroke;

    double expensesSweep = 2 * math.pi * (expenses);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      startAngle,
      expensesSweep,
      false,
      expensesPaint,
    );

    // Draw leftover
    final leftoverPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Color.fromARGB(255, 183, 186, 42)
      ..style = PaintingStyle.stroke;

    double leftoverSweep = 2 * math.pi * (leftover);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2 * strokeWidth),
      startAngle,
      leftoverSweep,
      false,
      leftoverPaint,
    );
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

  CalendarWeeklyView({required this.onDateSelected});

  @override
  State<CalendarWeeklyView> createState() => _CalendarWeeklyViewState();
}

class _CalendarWeeklyViewState extends State<CalendarWeeklyView> {
  int? groupValue = 0;
  List<DateTime> dates = []; // This will hold your dates

  @override
  void initState() {
    super.initState();
    _initDates();
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

  Widget buildSegment(String dateAbr, String datenumber, BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.075,
      width: MediaQuery.of(context).size.width * 0.9,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          dateAbr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(datenumber, style: TextStyle(fontSize: 14)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        calendarBox(context), // This displays the segmented control calendar
        // The VerticalList widget or equivalent logic to display expenses for the selected day should go here
      ],
    );
  }
}
