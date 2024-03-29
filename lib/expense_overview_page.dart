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
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
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
        title: Text('Expense Overview'),
        centerTitle: true,
      ),
      body: weeklyExpenses.isEmpty ||
              weekStartDates.isEmpty ||
              categoryExpenses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: Text(
                //     "Weekly Expenses",
                //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // Expanded(
                //   child: PageView.builder(
                //     controller: _pageController,
                //     itemCount: weeklyExpenses.length,
                //     onPageChanged: (int index) {
                //       setState(() {
                //         currentWeekIndex = index;
                //       });
                //     },
                //     itemBuilder: (context, index) {
                //       DateTime startDate = weekStartDates[index];
                //       DateTime endDate = startDate.add(Duration(days: 6));
                //       double totalExpenses =
                //           weeklyExpenses[index].reduce((a, b) => a + b);
                //       return buildExpenseCard(startDate, endDate,
                //           weeklyExpenses[index], totalExpenses);
                //     },
                //   ),
                // ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                          },
                        ),
                      )
                    ],
                  ),
                ),
                FutureBuilder<List<FlSpot>>(
                  future:
                      getThisWeeksExpenses(), // the async function returning spots
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading spinner if the data is not fetched yet
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Handle any errors here
                      return Center(child: Text('Error fetching data'));
                    }

                    // If we have data, build the LineChart widget
                    List<FlSpot> spots = snapshot.data ?? [];

                    return AspectRatio(
                      aspectRatio: 1.70,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: LineChart(
                          isWeekly
                              ? weeklyData(spots)
                              : monthlyData(), // pass the spots to the chart data method
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Category Expenses",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: CategoryPieChart(categoryExpenses: categoryExpenses),
                ),
              ],
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

  LineChartData weeklyData(List<FlSpot> spots) {
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
        ),
        leftTitles: SideTitles(showTitles: true),
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
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(colorList),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryExpenses.keys.map((category) {
              final colorIndex =
                  categoryExpenses.keys.toList().indexOf(category) %
                      colorList.length;
              final color = colorList[colorIndex];
              return Indicator(
                color: color,
                text: category,
                isSquare: true,
              );
            }).toList(),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Color> colorList) {
    final total = categoryExpenses.values.fold(0.0, (sum, item) => sum + item);
    var colorIndex = 0;

    return categoryExpenses.entries.map((entry) {
      final isTouched =
          false; // You can modify this to respond to touch interactions
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = colorList[colorIndex % colorList.length];

      colorIndex++;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${(entry.value / total * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
