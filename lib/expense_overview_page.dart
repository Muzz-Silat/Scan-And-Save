// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ExpenseOverviewPage extends StatefulWidget {
//   @override
//   _ExpenseOverviewPageState createState() => _ExpenseOverviewPageState();
// }

// class _ExpenseOverviewPageState extends State<ExpenseOverviewPage> {
//   PageController _pageController = PageController();
//   List<List<double>> weeklyExpenses = [];
//   List<DateTime> weekStartDates = [];
//   int currentWeekIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchWeeklyExpenses().then((result) {
//       setState(() {
//         weeklyExpenses = result;
//         weekStartDates = calculateWeekStartDates();
//         currentWeekIndex = weeklyExpenses.length - 1; // Set to last week
//         _pageController = PageController(initialPage: currentWeekIndex);
//       });
//     });
//   }

//   List<DateTime> calculateWeekStartDates() {
//     DateTime now = DateTime.now();
//     DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//     return List.generate(
//             4, (index) => startOfWeek.subtract(Duration(days: 7 * index)))
//         .reversed
//         .toList();
//   }

//   Future<List<List<double>>> fetchWeeklyExpenses() async {
//     List<List<double>> expenses = List.generate(4, (_) => List.filled(7, 0.0));
//     final user = FirebaseAuth.instance.currentUser;
//     DateTime now = DateTime.now();

//     if (user != null) {
//       DateTime fourWeeksAgo = now.subtract(Duration(days: 28));
//       var snapshot = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .collection('Expenses')
//           .where('date',
//               isGreaterThanOrEqualTo: Timestamp.fromDate(fourWeeksAgo))
//           .orderBy('date')
//           .get();

//       for (var doc in snapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         DateTime date = (data['date'] as Timestamp).toDate();
//         int weekIndex = calculateWeekIndex(date, fourWeeksAgo, now);
//         if (weekIndex >= 0 && weekIndex < 4) {
//           int dayOfWeek = date.weekday - 1;
//           expenses[weekIndex][dayOfWeek] += data['amount'] as double;
//         }
//       }
//     }
//     return expenses;
//   }

//   int calculateWeekIndex(DateTime date, DateTime fourWeeksAgo, DateTime now) {
//     int difference = date.difference(fourWeeksAgo).inDays;
//     return difference ~/ 7;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Expense Overview'),
//         centerTitle: true,
//       ),
//       body: weeklyExpenses.isEmpty || weekStartDates.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Text(
//                     "Weekly Expenses",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: weeklyExpenses.length,
//                     onPageChanged: (int index) {
//                       setState(() {
//                         currentWeekIndex = index;
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       DateTime startDate = weekStartDates[index];
//                       DateTime endDate = startDate.add(Duration(days: 6));
//                       double totalExpenses =
//                           weeklyExpenses[index].reduce((a, b) => a + b);
//                       return buildExpenseCard(startDate, endDate,
//                           weeklyExpenses[index], totalExpenses);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget buildExpenseCard(DateTime startDate, DateTime endDate,
//       List<double> weeklyExpenses, double totalExpenses) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Weekly Expenses: ${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d').format(endDate)}',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             'Total: \$${totalExpenses.toStringAsFixed(2)}',
//             style: TextStyle(fontSize: 16, color: Colors.green),
//           ),
//           SizedBox(height: 8),
//           AspectRatio(
//             aspectRatio: 2,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: BarChart(mainBarData(weeklyExpenses)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   BarChartData mainBarData(List<double> weeklyExpenses) {
//     List<BarChartGroupData> barGroups = [];
//     for (int i = 0; i < weeklyExpenses.length; i++) {
//       barGroups.add(
//         BarChartGroupData(
//           x: i,
//           barRods: [
//             BarChartRodData(
//               y: weeklyExpenses[i],
//               colors: [Colors.greenAccent, Colors.lightBlueAccent],
//               width: 16,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ],
//         ),
//       );
//     }

//     return BarChartData(
//       barTouchData: BarTouchData(
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.grey,
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             String weekDay;
//             switch (group.x.toInt()) {
//               case 0:
//                 weekDay = 'Mon';
//                 break;
//               case 1:
//                 weekDay = 'Tue';
//                 break;
//               case 2:
//                 weekDay = 'Wed';
//                 break;
//               case 3:
//                 weekDay = 'Thu';
//                 break;
//               case 4:
//                 weekDay = 'Fri';
//                 break;
//               case 5:
//                 weekDay = 'Sat';
//                 break;
//               case 6:
//                 weekDay = 'Sun';
//                 break;
//               default:
//                 throw Error();
//             }
//             return BarTooltipItem(
//               weekDay + '\n' + (rod.y).toString(),
//               const TextStyle(color: Colors.white),
//             );
//           },
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (context, value) => const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
//           margin: 16,
//           getTitles: (double value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Mon';
//               case 1:
//                 return 'Tue';
//               case 2:
//                 return 'Wed';
//               case 3:
//                 return 'Thu';
//               case 4:
//                 return 'Fri';
//               case 5:
//                 return 'Sat';
//               case 6:
//                 return 'Sun';
//               default:
//                 return '';
//             }
//           },
//         ),
//         leftTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         rightTitles: SideTitles(showTitles: false),
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       barGroups: weeklyExpenses.asMap().entries.map((entry) {
//         return BarChartGroupData(
//           x: entry.key,
//           barRods: [
//             BarChartRodData(
//               y: entry.value,
//               colors: [Colors.lightBlueAccent, Colors.greenAccent],
//               width: 16,
//               borderRadius: BorderRadius.all(Radius.circular(80)),
//             ),
//           ],
//         );
//       }).toList(),
//       gridData: FlGridData(show: false),
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:demo_flutter/components/segment_button.dart';
import 'package:demo_flutter/resources/colors.dart';

class ExpenseOverviewPage extends StatefulWidget {
  @override
  _ExpenseOverviewPageState createState() => _ExpenseOverviewPageState();
}

class _ExpenseOverviewPageState extends State<ExpenseOverviewPage> {
  PageController _pageController = PageController();
  List<List<double>> weeklyExpenses = [];
  List<DateTime> weekStartDates = [];
  int currentWeekIndex = 0;
  Map<String, double> categoryExpenses = {};
  bool isWeekly = true;

  @override
  void initState() {
    super.initState();
    fetchWeeklyExpenses().then((result) {
      setState(() {
        weeklyExpenses = result;
        weekStartDates = calculateWeekStartDates();
        currentWeekIndex = weeklyExpenses.length - 1; // Set to last week
        _pageController = PageController(initialPage: currentWeekIndex);
      });
      fetchCategoryExpenses();
    });
  }

  List<DateTime> calculateWeekStartDates() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(
            4, (index) => startOfWeek.subtract(Duration(days: 7 * index)))
        .reversed
        .toList();
  }

  Future<List<List<double>>> fetchWeeklyExpenses() async {
    List<List<double>> expenses = List.generate(4, (_) => List.filled(7, 0.0));
    final user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();

    if (user != null) {
      DateTime fourWeeksAgo = now.subtract(Duration(days: 28));
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Expenses')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(fourWeeksAgo))
          .orderBy('date')
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date = (data['date'] as Timestamp).toDate();
        int weekIndex = calculateWeekIndex(date, fourWeeksAgo, now);
        if (weekIndex >= 0 && weekIndex < 4) {
          int dayOfWeek = date.weekday - 1;
          expenses[weekIndex][dayOfWeek] += data['amount'] as double;
        }
      }
    }
    return expenses;
  }

  Future<void> fetchCategoryExpenses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DateTime now = DateTime.now();
    DateTime
        startOfPeriod; // This will either be the start of the current week or the start of the month.

    if (isWeekly) {
      // Calculate the start of the current week
      int dayOfWeek = now.weekday;
      // Adjusting to the start of the current week, considering Monday as the first day of the week
      DateTime startOfCurrentWeek = now.subtract(Duration(days: dayOfWeek - 1));
      startOfPeriod = DateTime(startOfCurrentWeek.year,
          startOfCurrentWeek.month, startOfCurrentWeek.day);
    } else {
      // Start of the current month
      startOfPeriod = DateTime(now.year, now.month, 1);
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfPeriod))
        .get();

    Map<String, double> tempCategoryExpenses = {};
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String category = data['category'];
      double amount = data['amount'] as double;
      if (tempCategoryExpenses.containsKey(category)) {
        tempCategoryExpenses[category] =
            tempCategoryExpenses[category]! + amount;
      } else {
        tempCategoryExpenses[category] = amount;
      }
    }

    setState(() {
      categoryExpenses = tempCategoryExpenses;
    });
  }

  int calculateWeekIndex(DateTime date, DateTime fourWeeksAgo, DateTime now) {
    int difference = date.difference(fourWeeksAgo).inDays;
    return difference ~/ 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Overview',
          style: TextStyle(fontFamily: "CourierPrime"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentButton(
                      title: "Weekly",
                      isActive: isWeekly,
                      onPressed: () {
                        setState(() {
                          isWeekly = true;
                        });
                        fetchCategoryExpenses();
                      },
                    ),
                  ),
                  Expanded(
                    child: SegmentButton(
                      title: "Monthly",
                      isActive: !isWeekly,
                      onPressed: () {
                        setState(() {
                          isWeekly = false;
                        });
                        fetchCategoryExpenses();
                      },
                    ),
                  )
                ],
              ),
            ),
            if (isWeekly)
              FutureBuilder<List<FlSpot>>(
                future: getThisWeeksExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  }
                  List<FlSpot> spots = snapshot.data ?? [];
                  final preferredCurrencyFuture = getPreferredCurrency();

                  return FutureBuilder<String>(
                    future: preferredCurrencyFuture,
                    builder: (context, currencySnapshot) {
                      if (!currencySnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      String preferredCurrency = currencySnapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black, // Background color
                            borderRadius:
                                BorderRadius.circular(18), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 16, top: 8),
                                    child: Text(
                                      preferredCurrency,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "CourierPrime"),
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1.70,
                                  child: LineChart(
                                      weeklyData(spots, preferredCurrency)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            else // Monthly BarChart
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Background color
                    borderRadius: BorderRadius.circular(18), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, top: 8),
                            child: FutureBuilder<String>(
                              future: getPreferredCurrency(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: "CourierPrime"),
                                );
                              },
                            ),
                          ),
                        ),
                        FutureBuilder<String>(
                          future: getPreferredCurrency(),
                          builder: (context, currencySnapshot) {
                            if (currencySnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (!currencySnapshot.hasData) {
                              return Center(
                                  child:
                                      Text('Error loading preferred currency'));
                            }
                            return FutureBuilder<BarChartData>(
                              future: prepareMonthlyBarChartData(
                                  currencySnapshot.data!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error loading chart data'));
                                }

                                // Assuming you have the horizontally scrollable bar chart logic here
                                double chartWidth =
                                    400.0; // Adjust based on your requirements
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: chartWidth,
                                    height: 220, // Adjust based on your design
                                    child: BarChart(snapshot.data!),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Expenses Categorised",
                style: TextStyle(fontSize: 24, fontFamily: "CourierPrime"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Background color
                  borderRadius: BorderRadius.circular(18), // Rounded corners
                ),
                child: CategoryPieChart(categoryExpenses: categoryExpenses),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<FlSpot>> getThisWeeksExpenses() async {
    List<double> thisWeeksExpenses = List.filled(7, 0.0);
    final user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();

    if (user != null) {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Expenses')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
          .orderBy('date')
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date = (data['date'] as Timestamp).toDate();
        int dayOfWeek = date.weekday - 1;
        thisWeeksExpenses[dayOfWeek] += data['amount'] as double;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < thisWeeksExpenses.length; i++) {
      spots.add(FlSpot(i.toDouble(), thisWeeksExpenses[i]));
    }
    return spots;
  }

  LineChartData weeklyData(List<FlSpot> spots, String preferredCurrency) {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 10,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Mon';
              case 1:
                return 'Tue';
              case 2:
                return 'Wed';
              case 3:
                return 'Thu';
              case 4:
                return 'Fri';
              case 5:
                return 'Sat';
              case 6:
                return 'Sun';
              default:
                return '';
            }
          },
          getTextStyles: (context, value) =>
              const TextStyle(fontFamily: "CourierPrime"),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              fontFamily: "CourierPrime",
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        topTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.transparent,
              fontSize: 0), // Make top titles invisible
        ),
        rightTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.transparent,
              fontSize: 0), // Make right titles invisible
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final day = getDayOfWeek(spot.x);
              return LineTooltipItem(
                '$day: ${NumberFormat.simpleCurrency(name: preferredCurrency).format(spot.y)}',
                const TextStyle(
                    color: Color.fromARGB(255, 103, 240, 173),
                    fontFamily: "CourierPrime"),
              );
            }).toList();
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d), width: 2.0),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: spots.map((spot) => spot.y).reduce(math.max) + 15,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: [Color.fromARGB(255, 103, 240, 173)],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
              show: true, colors: [Color.fromARGB(65, 103, 240, 173)]),
        ),
      ],
    );
  }

  Future<List<double>> getMonthlyExpenses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    // Assuming each document in your 'Expenses' collection has a 'date' (Timestamp) and 'amount' (double)
    var now = DateTime.now();
    var startOfYear = DateTime(now.year, 1, 1);
    var endOfYear = DateTime(now.year + 1, 1, 0);

    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfYear))
        .get();

    Map<int, double> monthlyExpenses = {};
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      var date = (data['date'] as Timestamp).toDate();
      var month = date.month;
      var amount = data['amount'] as double;

      if (!monthlyExpenses.containsKey(month)) {
        monthlyExpenses[month] = 0.0;
      }
      monthlyExpenses[month] = monthlyExpenses[month]! + amount;
    }

    // Assuming you want a list of 12 elements, one for each month of the year
    List<double> expensesPerMonth =
        List.generate(12, (index) => monthlyExpenses[index + 1] ?? 0.0);

    return expensesPerMonth;
  }

  Future<BarChartData> prepareMonthlyBarChartData(
      String preferredCurrency) async {
    List<double> monthlyExpenses = await getMonthlyExpenses();

    // Adjusting the bar width and spacing
    final double barWidth = 22; // Adjust this value as needed
    final double barSpacing = 12; // Adjust space between bars

    List<BarChartGroupData> barGroups =
        List.generate(monthlyExpenses.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: barSpacing, // Spacing between bars
        barRods: [
          BarChartRodData(
            y: monthlyExpenses[index],
            width: barWidth, // Adjust the width of the bars
            colors: [
              Color.fromARGB(255, 103, 240, 173)
            ], // Use the same color as your weekly chart
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });

    return BarChartData(
      alignment: BarChartAlignment.spaceBetween,
      maxY: monthlyExpenses.reduce(math.max) + 100, // Adjust based on your data
      barGroups: barGroups,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              fontFamily: "CourierPrime",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) => monthName(value.toInt()),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          margin: 8, // Reduce the margin if necessary
          reservedSize:
              30, // Adjust according to your TextStyle to avoid wrapping
          getTextStyles: (context, value) => const TextStyle(
              fontFamily: "CourierPrime",
              fontSize:
                  14, // Ensure the font size is small enough to fit in one line
              fontWeight: FontWeight.bold),
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.black,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final month = monthName(
                group.x); // Assuming you have a method to get the month name
            return BarTooltipItem(
              '$month: ${NumberFormat.simpleCurrency(name: preferredCurrency).format(rod.y)}',
              const TextStyle(
                color: Color.fromARGB(255, 103, 240, 173),
                fontFamily: "CourierPrime",
                fontSize: 14,
              ),
            );
          },
        ),
      ),
    );
  }

  String monthName(int monthIndex) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[monthIndex % 12];
  }

  // Monthly data configuration for the line chart
  LineChartData monthlyData() {
    return LineChartData(
      // Configure the rest of your line chart settings
      // ...

      // You should replace this with your actual data points
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 2), // Example data point for week 1
            FlSpot(1, 5), // Example data point for week 2
            // Add the rest of your month's data points
          ],
          // Other configurations like colors, dotData, etc.
        ),
      ],
    );
  }

  String getDayOfWeek(double xValue) {
    switch (xValue.toInt()) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }

  Future<String> getPreferredCurrency() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 'USD'; // Default currency if not logged in or unable to fetch
    }

    try {
      // Attempt to fetch the preferred currency setting from Firestore
      var settingsDocument = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Preferences')
          .doc('Settings')
          .get();

      if (settingsDocument.exists) {
        // Assuming 'PreferredCurrency' field exists and is a string
        String preferredCurrency =
            settingsDocument.data()?['PreferredCurrency'] ?? 'USD';
        return preferredCurrency;
      }
    } catch (e) {
      // Handle errors, e.g., due to network issues, permissions, etc.
      print("Error fetching preferred currency: $e");
    }

    return 'USD'; // Default currency if there's an error fetching
  }

  Widget buildExpenseCard(DateTime startDate, DateTime endDate,
      List<double> weeklyExpenses, double totalExpenses) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Weekly Expenses: ${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d').format(endDate)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Total: \$${totalExpenses.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
          SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BarChart(mainBarData(weeklyExpenses)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData(List<double> weeklyExpenses) {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < weeklyExpenses.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: weeklyExpenses[i],
              colors: [Colors.greenAccent, Colors.lightBlueAccent],
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x.toInt()) {
              case 0:
                weekDay = 'Mon';
                break;
              case 1:
                weekDay = 'Tue';
                break;
              case 2:
                weekDay = 'Wed';
                break;
              case 3:
                weekDay = 'Thu';
                break;
              case 4:
                weekDay = 'Fri';
                break;
              case 5:
                weekDay = 'Sat';
                break;
              case 6:
                weekDay = 'Sun';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              weekDay + '\n' + (rod.y).toString(),
              const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Mon';
              case 1:
                return 'Tue';
              case 2:
                return 'Wed';
              case 3:
                return 'Thu';
              case 4:
                return 'Fri';
              case 5:
                return 'Sat';
              case 6:
                return 'Sun';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(show: false),
      barGroups: weeklyExpenses.asMap().entries.map((entry) {
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              y: entry.value,
              colors: [Colors.lightBlueAccent, Colors.greenAccent],
              width: 16,
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
          ],
        );
      }).toList(),
      gridData: FlGridData(show: false),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;

  const CategoryPieChart({Key? key, required this.categoryExpenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colorList = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.pink,
      Colors.teal,
      // Add more colors as needed
    ];

    // Generate PieChartSectionData from categoryExpenses
    List<PieChartSectionData> sections = categoryExpenses.keys
        .toList()
        .asMap()
        .map((index, key) {
          final value = categoryExpenses[key]!;
          return MapEntry(
            index,
            PieChartSectionData(
              color: colorList[index % colorList.length],
              value: value,
              title:
                  '${(value / categoryExpenses.values.reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%',
              radius: 50, // Adjust the radius for the size you want
              titleStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "CourierPrime"),
            ),
          );
        })
        .values
        .toList();

    return Container(
      margin: EdgeInsets.all(16), // Add some margin for aesthetics
      padding: EdgeInsets.all(16), // Add padding inside the container
      decoration: BoxDecoration(
        color: Colors.black, // Dark background color
        borderRadius: BorderRadius.circular(18), // Rounded corners
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Make the column's size fit its children
        children: [
          SizedBox(
            // Specify a size for the PieChart for more control over its size
            height: MediaQuery.of(context).size.width *
                0.6, // Example dynamic sizing
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 30, // Adjust the size of the inner circle
                sectionsSpace: 0, // Adjust the space between sections
              ),
            ),
          ),
          SizedBox(height: 16), // Add some spacing before the legend list
          // Display category expenses as a list without ListView to avoid nested scrolling issues
          ...categoryExpenses.entries.map((entry) {
            final colorIndex =
                categoryExpenses.keys.toList().indexOf(entry.key) %
                    colorList.length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Indicator(
                color: colorList[colorIndex],
                text: '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                isSquare: false,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "CourierPrime"),
        )
      ],
    );
  }
}
