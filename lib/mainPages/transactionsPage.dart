// // ignore_for_file: file_names, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, use_key_in_widget_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:demo_flutter/theme_bloc.dart';
// import 'package:demo_flutter/theme_event.dart';

// class PastTransactionsPage extends StatefulWidget {
//   const PastTransactionsPage({Key? key}) : super(key: key);

//   @override
//   State<PastTransactionsPage> createState() => _PastTransactionsPageState();
// }

// class _PastTransactionsPageState extends State<PastTransactionsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Past Transactions",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.brightness_6),
//             onPressed: () {
//               // Toggling the theme using Bloc
//               final themeBloc = BlocProvider.of<ThemeBloc>(context);
//               themeBloc.add(ThemeChanged(
//                   isDarkMode: themeBloc.state.themeData.brightness ==
//                       Brightness.light));
//             },
//           ),
//         ],
//       ),
//       body: Container(child: UpcomingTransactionsList()),
//     );
//   }
// }

// final Map<String, IconData> categoryIcons = {
//   'Food': Icons.fastfood,
//   'Transport': Icons.directions_car,
//   'Shopping': Icons.shopping_cart,
//   // Add more categories and their corresponding icons
// };

// class UpcomingTransactionsList extends StatefulWidget {
//   const UpcomingTransactionsList();

//   @override
//   State<UpcomingTransactionsList> createState() =>
//       _UpcomingTransactionsListState();
// }

// class _UpcomingTransactionsListState extends State<UpcomingTransactionsList> {
//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return Center(child: Text("Please login to see transactions."));
//     }
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .collection('Expenses')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }
//         var expenses = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: expenses.length,
//           itemBuilder: (context, index) {
//             var expense = expenses[index].data()
//                 as Map<String, dynamic>; // Cast the data to a Map
//             DateTime date = (expense['date'] as Timestamp).toDate();
//             double amount = expense['amount'];
//             String description = expense['description'];
//             String currency = expense.containsKey('currency')
//                 ? expense['currency'] as String
//                 : 'USD'; // Default to USD if missing
//             // Provide a default value if the category field is missing
//             String category = expense.containsKey('category')
//                 ? expense['category'] as String
//                 : 'Uncategorized';

//             // Use the currency field to determine the correct currency symbol
//             final format = NumberFormat.simpleCurrency(name: currency);
//             String formattedAmount = format
//                 .format(amount); // Format the amount with the currency symbol

//             Icon icon = Icon(
//               categoryIcons[category] ??
//                   Icons.category, // Use a default icon if category is not found
//               size: 40,
//             );

//             return SizedBox(
//               width: MediaQuery.of(context).size.width * 0.9,
//               child: ListTile(
//                 leading: icon,
//                 title: Text(
//                   formattedAmount,
//                   style: TextStyle(color: Colors.greenAccent),
//                 ),
//                 subtitle: Text(description),
//                 trailing: Text(DateFormat.MMMMEEEEd().format(date).toString()),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:demo_flutter/currency_conversion.dart';
import 'package:demo_flutter/theme_bloc.dart';
import 'package:demo_flutter/theme_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_flutter/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:demo_flutter/expense.dart';
import 'package:demo_flutter/expense_overview_page.dart';

class PastTransactionsPage extends StatefulWidget {
  const PastTransactionsPage({Key? key}) : super(key: key);

  @override
  State<PastTransactionsPage> createState() => _PastTransactionsPageState();
}

class _PastTransactionsPageState extends State<PastTransactionsPage> {
  int touchedIndex = -1;
  String sortType = 'Recent'; // Variable to track the current sort type
  String preferredCurrency = 'USD';
  bool isLoading = true;
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'all';
  String? _selectedCategory;
  List<DocumentSnapshot> _filteredExpenses = [];
  CurrencyService currencyService = CurrencyService();
  final FirestoreService _firestoreService = FirestoreService();
  List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AED'];
  List<String> categories = [
    'Groceries',
    'Dining Out',
    'Transport',
    'Entertainment',
    'Travel',
    'Education',
    'Clothing & Accessories',
    'Miscellaneous'
  ];
  @override
  void initState() {
    super.initState();
    fetchPreferredCurrency();
    _fetchExpenses();
  }

  void _fetchExpenses() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime lastDayOfWeek = firstDayOfWeek
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    Query query = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses');

    if (_selectedFilter == 'today') {
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfToday)
          .where('date', isLessThanOrEqualTo: endOfToday);
    } else if (_selectedFilter == 'this_week') {
      query = query
          .where('date', isGreaterThanOrEqualTo: firstDayOfWeek)
          .where('date', isLessThanOrEqualTo: lastDayOfWeek);
    }
    // For 'this_month'
    else if (_selectedFilter == 'this_month') {
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth);
    }
// For 'this_year'
    else if (_selectedFilter == 'this_year') {
      DateTime startOfYear = DateTime(now.year, 1, 1);
      DateTime endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfYear)
          .where('date', isLessThanOrEqualTo: endOfYear);
    }
// For 'all', you don't need to apply a date filter.
    else if (_selectedFilter == 'all') {
      // No additional filtering required for 'all'
    }

    // If a category is selected, further filter the query
    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    // Fetch the data from Firestore and update the state
    query.get().then((snapshot) {
      setState(() {
        _filteredExpenses = snapshot.docs;
      });
    });
  }

  // New method to update the time period filter and fetch expenses
  void _onFilterChanged(String newFilter) {
    setState(() {
      _selectedFilter = newFilter;
      _fetchExpenses(); // Fetch expenses after changing the filter
    });
  }

  // New method to update the category filter and fetch expenses
  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
      _fetchExpenses(); // Fetch expenses after changing the category
    });
  }

  // New method to pick a date and fetch expenses for that date
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedFilter =
            'custom'; // Set to 'custom' to indicate a specific date
        _fetchExpenses(); // Fetch expenses after picking a date
      });
    }
  }

  Future<void> fetchPreferredCurrency() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Preferences')
          .doc('Settings')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists &&
            snapshot.data()!.containsKey('PreferredCurrency')) {
          setState(() {
            preferredCurrency = snapshot.data()!['PreferredCurrency'];
            isLoading = false; // Done loading preferred currency
          });
        }
      });
    } else {
      setState(() {
        isLoading = false; // No user logged in, stop loading
      });
    }
  }

  void sortExpenses(List<QueryDocumentSnapshot> expenses) {
    if (sortType == 'Highest') {
      expenses.sort((a, b) => (b.data() as Map<String, dynamic>)['amount']
          .compareTo((a.data() as Map<String, dynamic>)['amount']));
    } else if (sortType == 'Recent') {
      expenses.sort((a, b) => (b.data() as Map<String, dynamic>)['date']
          .compareTo((a.data() as Map<String, dynamic>)['date']));
    }
  }

  Map<String, double> aggregateExpensesByCategory(
      List<QueryDocumentSnapshot> expenses) {
    Map<String, double> categorySums = {};
    for (var doc in expenses) {
      final expense = doc.data() as Map<String, dynamic>;
      final category = expense['category'] ?? 'Uncategorized';
      final amount = expense['amount'] as double;
      categorySums.update(category, (value) => value + amount,
          ifAbsent: () => amount);
    }
    return categorySums;
  }

  // Common widget for all time filter buttons and the calendar button
  Widget _filterButton(String title, IconData? iconData, String filter) {
    bool isSelected = _selectedFilter == filter;
    EdgeInsets padding = iconData == null
        ? EdgeInsets.fromLTRB(12, 12, 12, 9)
        : EdgeInsets.symmetric(vertical: 8, horizontal: 12);

    return GestureDetector(
      onTap: iconData == null ? () => _onFilterChanged(filter) : _pickDate,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
          ),
        ),
        child: iconData == null
            ? Text(
                title,
                style: TextStyle(
                  fontFamily: "CourierPrime",
                  color: isSelected
                      ? Colors.black
                      : Theme.of(context).iconTheme.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            : Icon(
                iconData,
                size: 20,
                color: isSelected
                    ? Colors.black
                    : Theme.of(context).iconTheme.color,
              ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> filteredExpensesStream() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user found");
    }

    var now = DateTime.now();

    // Calculate the start of the day for 'today' filter
    var startOfDay = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
    var endOfDay =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day, 23, 59, 59));

    // Calculate the start and end of the week
    // Assuming the week starts on Monday (set `weekday` to 7 for Sunday)
    var firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    var lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

    var startOfWeek = Timestamp.fromDate(DateTime(
        firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day));
    var endOfWeek = Timestamp.fromDate(DateTime(lastDayOfWeek.year,
        lastDayOfWeek.month, lastDayOfWeek.day, 23, 59, 59));

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshots, _) => snapshots.data()!,
          toFirestore: (expense, _) => expense,
        );

    // Apply time filter based on _selectedFilter
    if (_selectedFilter == 'today') {
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay);
    } else if (_selectedFilter == 'this_week') {
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThanOrEqualTo: endOfWeek);
    }
    // For 'this_month'
    else if (_selectedFilter == 'this_month') {
      var startOfMonth = Timestamp.fromDate(DateTime(now.year, now.month, 1));
      var endOfMonth =
          Timestamp.fromDate(DateTime(now.year, now.month + 1, 0, 23, 59, 59));
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth);
    }
// For 'this_year'
    else if (_selectedFilter == 'this_year') {
      var startOfYear = Timestamp.fromDate(DateTime(now.year, 1, 1));
      var endOfYear =
          Timestamp.fromDate(DateTime(now.year, 12, 31, 23, 59, 59));
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfYear)
          .where('date', isLessThanOrEqualTo: endOfYear);
    } else if (_selectedFilter == 'custom') {
      // For 'custom' filter, use _selectedDate to filter expenses
      var customStartOfDay = Timestamp.fromDate(
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day));
      var customEndOfDay = Timestamp.fromDate(DateTime(_selectedDate.year,
          _selectedDate.month, _selectedDate.day, 23, 59, 59));
      query = query
          .where('date', isGreaterThanOrEqualTo: customStartOfDay)
          .where('date', isLessThanOrEqualTo: customEndOfDay);
    }

    // Apply category filter if one is selected
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    return query.snapshots();
  }

  void editExpense(BuildContext context, String expenseId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('No user logged in. Please log in to edit expenses.')),
      );
      return;
    }

    final expenseDetails =
        await _firestoreService.getExpenseDetails(user.uid, expenseId);
    double oldAmount =
        double.tryParse(expenseDetails['amount'].toString()) ?? 0.0;
    String oldCategory = expenseDetails['category'];
    final _amountController =
        TextEditingController(text: expenseDetails['amount'].toString());
    final _descriptionController =
        TextEditingController(text: expenseDetails['description']);
    DateTime _selectedDate = expenseDetails['date']
        .toDate(); // Make sure to convert Timestamp to DateTime
    String _selectedCurrency = expenseDetails['currency'];
    String _selectedCategory = expenseDetails['category'];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  DropdownButtonFormField(
                    value: _selectedCurrency,
                    decoration: InputDecoration(labelText: 'Currency'),
                    items: currencies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    value: _selectedCategory,
                    decoration: InputDecoration(labelText: 'Category'),
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      double newAmount = double.parse(_amountController.text);
                      String newCategory = _selectedCategory;

                      // Fetch current budget settings
                      var settingsDoc = await firestore
                          .collection('Users')
                          .doc(user.uid)
                          .collection('Preferences')
                          .doc('Settings')
                          .get();
                      Map<String, dynamic> settings = settingsDoc.data() ?? {};
                      Map<String, double> categoryBudgets =
                          Map<String, double>.from(
                              settings['categoryBudgets'] ?? {});
                      double totalBudget = settings['totalBudget'] ?? 0;

                      // Calculate the difference and adjust budgets
                      double amountDifference = newAmount - oldAmount;
                      categoryBudgets[oldCategory] =
                          (categoryBudgets[oldCategory] ?? 0) -
                              amountDifference;
                      if (oldCategory != newCategory) {
                        categoryBudgets[newCategory] =
                            (categoryBudgets[newCategory] ?? 0) + newAmount;
                      }
                      totalBudget -= amountDifference;

                      // Save updated budgets back to Firestore
                      await firestore
                          .collection('Users')
                          .doc(user.uid)
                          .collection('Preferences')
                          .doc('Settings')
                          .set({
                        'categoryBudgets': categoryBudgets,
                        'totalBudget': totalBudget
                      }, SetOptions(merge: true));

                      // Update the expense with new details
                      await _firestoreService.updateExpense(
                        user.uid,
                        expenseId,
                        Expense(
                          amount: double.parse(_amountController.text),
                          description: _descriptionController.text,
                          date: _selectedDate,
                          currency: _selectedCurrency,
                          category: _selectedCategory,
                        ).toMap(),
                        // Your Expense.toMap() method here...
                      );

                      Navigator.pop(context);
                    },
                    child: Text('Update Expense'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // void editExpense(BuildContext context, String expenseId) async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     // Handle the case where there is no user logged in
  //     // For example, show a message or redirect to the login page
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content:
  //               Text('No user logged in. Please log in to edit expenses.')),
  //     );
  //     return;
  //   }
  //   final expenseDetails =
  //       await _firestoreService.getExpenseDetails(user.uid, expenseId);

  //   // Assuming expenseDetails is a map that contains all the fields
  //   final _amountController =
  //       TextEditingController(text: expenseDetails['amount'].toString());
  //   final _descriptionController =
  //       TextEditingController(text: expenseDetails['description']);
  //   DateTime _selectedDate = expenseDetails['date']
  //       .toDate(); // Make sure to convert Timestamp to DateTime
  //   String _selectedCurrency = expenseDetails['currency'];
  //   String _selectedCategory = expenseDetails['category'];

  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setModalState) {
  //           return Container(
  //             padding: EdgeInsets.all(16),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 TextField(
  //                   controller: _amountController,
  //                   decoration: InputDecoration(labelText: 'Amount'),
  //                   keyboardType:
  //                       TextInputType.numberWithOptions(decimal: true),
  //                 ),
  //                 TextField(
  //                   controller: _descriptionController,
  //                   decoration: InputDecoration(labelText: 'Description'),
  //                 ),
  //                 DropdownButtonFormField(
  //                   value: _selectedCurrency,
  //                   decoration: InputDecoration(labelText: 'Currency'),
  //                   items: currencies
  //                       .map<DropdownMenuItem<String>>((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _selectedCurrency = newValue!;
  //                     });
  //                   },
  //                 ),
  //                 DropdownButtonFormField(
  //                   value: _selectedCategory,
  //                   decoration: InputDecoration(labelText: 'Category'),
  //                   items: categories
  //                       .map<DropdownMenuItem<String>>((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _selectedCategory = newValue!;
  //                     });
  //                   },
  //                 ),
  //                 // Add fields for date, currency, and category similar to your add expense form
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     // Update the expense with new details
  //                     await _firestoreService.updateExpense(
  //                       user.uid,
  //                       expenseId,
  //                       Expense(
  //                         amount: double.parse(_amountController.text),
  //                         description: _descriptionController.text,
  //                         date: _selectedDate,
  //                         currency: _selectedCurrency,
  //                         category: _selectedCategory,
  //                       ).toMap(),
  //                     );

  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Update Expense'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget categoryOptions(BuildContext context) {
    final categoriesList = categoryIcons.keys.toList();
    Map<int, Widget> children = categoriesList.asMap().map(
          (index, category) => MapEntry(
            index,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    categoryIcons[category],
                    size: 24,
                    color: _selectedCategory == category ? Colors.black : null,
                  ),
                ],
              ),
            ),
          ),
        );

    // Find the current groupValue based on the selected category
    int? groupValue = _selectedCategory != null
        ? categoriesList.indexOf(_selectedCategory!)
        : null;

    return Container(
      alignment: Alignment.center,
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: Colors.transparent,
        thumbColor: Colors.greenAccent,
        padding: const EdgeInsets.all(8),
        groupValue: groupValue != null && groupValue >= 0 ? groupValue : null,
        // Handle if no category is selected
        children: children,
        onValueChanged: (value) {
          if (value != null) {
            setState(() {
              // Update the selected category based on the selected segment
              _selectedCategory = categoriesList[value];
              _onCategoryChanged(
                  _selectedCategory); // Call the method to handle category change
            });
          }
        },
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("Please login to see transactions."));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Past Transactions",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "CourierPrime",
              fontSize: 24),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: filteredExpensesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var expenses = snapshot.data!.docs;
          sortExpenses(expenses);

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      _filterButton('Today', null, 'today'),
                      _filterButton('Week', null, 'this_week'),
                      _filterButton('Month', null, 'this_month'),
                      _filterButton('Year', null, 'this_year'),
                      _filterButton('All', null, 'all'),
                      _filterButton('', Icons.calendar_today, 'custom'),
                    ],
                  ),
                ),
                categoryOptions(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // PopupMenuButton for sorting options with a filter list icon
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.filter_list, color: Colors.white),
                    onSelected: (String value) {
                      setState(() {
                        sortType = value;
                      });
                      _fetchExpenses(); // Make sure to call a method that re-fetches or sorts the expenses based on the new sortType
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Recent',
                        child: Row(
                          children: const [
                            Icon(Icons.new_releases,
                                color: Colors
                                    .black), // Example icon for 'Most Recent'
                            SizedBox(width: 8),
                            Text('Most Recent'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Highest',
                        child: Row(
                          children: const [
                            Icon(Icons.trending_up,
                                color: Colors
                                    .black), // Example icon for 'Highest Amount'
                            SizedBox(width: 8),
                            Text('Highest Amount'),
                          ],
                        ),
                      ),
                      // Add other sorting options here with icons
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    var expenseDoc = expenses[index];
                    var expense = expenseDoc.data() as Map<String, dynamic>;
                    DateTime date = (expense['date'] as Timestamp).toDate();
                    double amount = expense['amount'];
                    String description =
                        expense['description'] ?? 'No description';
                    String currency = expense['currency'] ??
                        'USD'; // Default to USD if not specified
                    String category = expense['category'] ?? 'Uncategorized';

                    // Currency conversion logic replaced with a FutureBuilder to handle async operation
                    return FutureBuilder<double>(
                      future: currency == preferredCurrency
                          ? Future.value(
                              amount) // If the currency is already preferred, no conversion needed
                          : currencyService.convertCurrency(amount, currency,
                              preferredCurrency), // Perform conversion
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text("Converting currency..."),
                            subtitle: Text(description),
                            trailing: Text(DateFormat.MMMMEEEEd().format(date)),
                          );
                        }

                        double convertedAmount = snapshot.data ?? amount;
                        String formattedAmount =
                            NumberFormat.simpleCurrency(name: preferredCurrency)
                                .format(convertedAmount);
                        String dateS = DateFormat.MMMMEEEEd().format(date);

                        return Dismissible(
                          key: Key(expenseDoc.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            final bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm'),
                                  content: Text(
                                      'Are you sure you want to delete this expense?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmDelete) {
                              final String userId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final DocumentSnapshot expenseSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(userId)
                                      .collection('Expenses')
                                      .doc(expenseDoc.id)
                                      .get();

                              final double amountToDelete =
                                  expenseSnapshot['amount'];
                              final String categoryToDelete =
                                  expenseSnapshot['category'];

                              // Fetch current budget settings
                              final DocumentSnapshot settingsSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(userId)
                                      .collection('Preferences')
                                      .doc('Settings')
                                      .get();

                              Map<String, dynamic> settings = settingsSnapshot
                                      .data() as Map<String, dynamic> ??
                                  {};
                              Map<String, double> categoryBudgets =
                                  Map<String, double>.from(
                                      settings['categoryBudgets'] ?? {});
                              double totalBudget = settings['totalBudget'] ?? 0;

                              // Adjust the category and total budget
                              categoryBudgets[categoryToDelete] =
                                  (categoryBudgets[categoryToDelete] ?? 0) +
                                      amountToDelete;
                              totalBudget += amountToDelete;

                              // Update the budget settings
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(userId)
                                  .collection('Preferences')
                                  .doc('Settings')
                                  .set({
                                'categoryBudgets': categoryBudgets,
                                'totalBudget': totalBudget
                              }, SetOptions(merge: true));

                              // Proceed with deletion
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(userId)
                                  .collection('Expenses')
                                  .doc(expenseDoc.id)
                                  .delete();
                            }
                            return confirmDelete;
                          },
                          child: ListTile(
                            leading: Icon(
                              categoryIcons[category] ?? Icons.help_outline,
                              size: 40,
                              color: Colors.greenAccent,
                            ),
                            title: Text(
                              '$description',
                              style: TextStyle(fontFamily: "CourierPrime"),
                            ),
                            subtitle: Text(
                              '$formattedAmount',
                              style: TextStyle(fontFamily: "CourierPrime"),
                            ),
                            trailing: Text(
                              '$dateS',
                              style: TextStyle(fontFamily: "CourierPrime"),
                            ),
                            onTap: () {
                              editExpense(context, expenseDoc.id);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ExpenseOverviewPage())),
                    child: Text('View Expense Overview'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .primaryColor, // Use the theme's primary color
                      foregroundColor: Colors.white, // Text color
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
