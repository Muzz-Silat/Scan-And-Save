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

  void editExpense(BuildContext context, String expenseId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where there is no user logged in
      // For example, show a message or redirect to the login page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('No user logged in. Please log in to edit expenses.')),
      );
      return;
    }
    final expenseDetails =
        await _firestoreService.getExpenseDetails(user.uid, expenseId);

    // Assuming expenseDetails is a map that contains all the fields
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
                  // Add fields for date, currency, and category similar to your add expense form
                  ElevatedButton(
                    onPressed: () async {
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Expenses')
            .snapshots(),
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
                  child: DropdownButton<String>(
                    value: sortType,
                    onChanged: (value) {
                      setState(() {
                        sortType = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                          value: 'Recent', child: Text('Most Recent')),
                      DropdownMenuItem(
                          value: 'Highest', child: Text('Highest Amount')),
                      // Add other sorting options here
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

                        double convertedAmount = snapshot.data ??
                            amount; // Use original amount as fallback
                        String formattedAmount =
                            NumberFormat.simpleCurrency(name: preferredCurrency)
                                .format(convertedAmount);

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
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Expenses')
                                  .doc(expenseDoc.id)
                                  .delete();
                            }
                            return confirmDelete;
                          },
                          child: ListTile(
                            leading: Icon(
                                categoryIcons[category] ?? Icons.help_outline,
                                size: 40),
                            title: Text(formattedAmount),
                            subtitle: Text(description),
                            trailing: Text(DateFormat.MMMMEEEEd().format(date)),
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
//       body: UpcomingTransactionsList(),
//     );
//   }
// }

// class UpcomingTransactionsList extends StatefulWidget {
//   const UpcomingTransactionsList();

//   @override
//   State<UpcomingTransactionsList> createState() =>
//       _UpcomingTransactionsListState();
// }

// class _UpcomingTransactionsListState extends State<UpcomingTransactionsList> {
//   int touchedIndex = -1;
//   String sortType = 'Recent'; // Variable to track the current sort type

//   // Function to sort expenses based on the selected sort type
//   void sortExpenses(List<QueryDocumentSnapshot> expenses) {
//     if (sortType == 'Highest') {
//       expenses.sort((a, b) => (b.data() as Map<String, dynamic>)['amount']
//           .compareTo((a.data() as Map<String, dynamic>)['amount']));
//     } else if (sortType == 'Recent') {
//       expenses.sort((a, b) => (b.data() as Map<String, dynamic>)['date']
//           .compareTo((a.data() as Map<String, dynamic>)['date']));
//     }
//     // Add more sorting options as needed
//   }

//   final Map<String, IconData> categoryIcons = {
//     'Groceries': Icons.shopping_cart,
//     'Dining Out': Icons.restaurant,
//     'Transport': Icons.directions_car,
//     'Entertainment': Icons.movie,
//     'Travel': Icons.airplanemode_active,
//     'Education': Icons.school,
//     'Clothing & Accessories': Icons.checkroom,
//     'Miscellaneous': Icons.miscellaneous_services,
//   };

//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return Center(child: Text("Please login to see transactions."));
//     }

//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Users')
//             .doc(user.uid)
//             .collection('Expenses')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           var expenses = snapshot.data!.docs;
//           sortExpenses(expenses);
//           Map<String, double> categorySums =
//               aggregateExpensesByCategory(expenses);

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 16.0), // Adjust the value as needed for your design
//                   child: Text(
//                     'Expenses Breakdown',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//                 if (categorySums.isNotEmpty) ...[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Container(
//                       height: 200, // Define a fixed height for the PieChart
//                       child: buildCategoryPieChart(categorySums),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: buildChartKey(categorySums),
//                   ),
//                   SizedBox(
//                       height: 16), // Margin between the pie chart and the list
//                 ],
//                 // Sort button or dropdown
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DropdownButton<String>(
//                     value: sortType,
//                     onChanged: (value) {
//                       setState(() {
//                         sortType = value!;
//                       });
//                     },
//                     items: [
//                       DropdownMenuItem(
//                           value: 'Recent', child: Text('Most Recent')),
//                       DropdownMenuItem(
//                           value: 'Highest', child: Text('Highest Amount')),
//                       // Add other sorting options here
//                     ],
//                   ),
//                 ),

//                 // ListView.builder(
//                 //   shrinkWrap: true,
//                 //   physics: NeverScrollableScrollPhysics(),
//                 //   itemCount: expenses.length,
//                 //   itemBuilder: (context, index) {
//                 //     var expense =
//                 //         expenses[index].data() as Map<String, dynamic>;
//                 //     DateTime date = (expense['date'] as Timestamp).toDate();
//                 //     double amount = expense['amount'];
//                 //     String description = expense['description'];
//                 //     String currency = expense['currency'] ?? 'USD';
//                 //     String category = expense['category'] ?? 'Uncategorized';
//                 //     final format = NumberFormat.simpleCurrency(name: currency);
//                 //     String formattedAmount = format.format(amount);
//                 //     return ListTile(
//                 //       leading: Icon(
//                 //           categoryIcons[category] ?? Icons.help_outline,
//                 //           size: 40),
//                 //       title: Text(formattedAmount),
//                 //       subtitle: Text(description),
//                 //       trailing: Text(DateFormat.MMMMEEEEd().format(date)),
//                 //     );
//                 //   },
//                 // ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: expenses.length,
//                   itemBuilder: (context, index) {
//                     var expenseDoc = expenses[index];
//                     var expense = expenseDoc.data() as Map<String, dynamic>;
//                     DateTime date = (expense['date'] as Timestamp).toDate();
//                     double amount = expense['amount'];
//                     String description = expense['description'];
//                     String currency = expense['currency'] ?? 'USD';
//                     String category = expense['category'] ?? 'Uncategorized';
//                     final format = NumberFormat.simpleCurrency(name: currency);
//                     String formattedAmount = format.format(amount);

//                     return Dismissible(
//                       key: Key(expenseDoc.id),
//                       direction: DismissDirection.endToStart,
//                       background: Container(
//                         color: Colors.red,
//                         alignment: Alignment.centerRight,
//                         padding: EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Icon(Icons.delete, color: Colors.white),
//                       ),
//                       confirmDismiss: (direction) async {
//                         final bool confirmDelete = await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Confirm'),
//                               content: Text(
//                                   'Are you sure you want to delete this expense?'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(true),
//                                   child: Text('Delete'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(false),
//                                   child: Text('Cancel'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                         if (confirmDelete) {
//                           // Perform deletion
//                           FirebaseFirestore.instance
//                               .collection('Users')
//                               .doc(FirebaseAuth.instance.currentUser!.uid)
//                               .collection('Expenses')
//                               .doc(expenseDoc.id)
//                               .delete();
//                         }
//                         return confirmDelete;
//                       },
//                       child: ListTile(
//                         leading: Icon(
//                             categoryIcons[category] ?? Icons.help_outline,
//                             size: 40),
//                         title: Text(formattedAmount),
//                         subtitle: Text(description),
//                         trailing: IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () =>
//                               editExpense(context, expenseDoc.id, expense),
//                         ),
//                         onTap: () {
//                           // Implement what happens when you tap on the expense
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   void editExpense(BuildContext context, String expenseId,
//       Map<String, dynamic> expenseData) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         // Return your edit form here
//         return Container(
//           padding: EdgeInsets.all(16),
//           height: 500, // Modify as per your design
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 // Pre-fill the text fields with current expense data
//                 controller:
//                     TextEditingController(text: expenseData['description']),
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//               TextField(
//                 controller: TextEditingController(
//                     text: expenseData['amount'].toString()),
//                 decoration: InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//               ),
//               // Add other fields for editing as necessary
//               ElevatedButton(
//                 child: Text('Update Expense'),
//                 onPressed: () {
//                   // Update the expense in Firestore
//                   // Close the bottom sheet
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Map<String, double> aggregateExpensesByCategory(
//       List<QueryDocumentSnapshot> expenses) {
//     Map<String, double> categorySums = {};
//     for (var doc in expenses) {
//       final expense = doc.data() as Map<String, dynamic>;
//       final category = expense['category'] ?? 'Uncategorized';
//       final amount = expense['amount'] as double;
//       categorySums.update(category, (value) => value + amount,
//           ifAbsent: () => amount);
//     }
//     return categorySums;
//   }

//   // Function to build the pie chart key
//   Widget buildChartKey(Map<String, double> categorySums) {
//     List<Widget> keys = categorySums.keys.map((key) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(categoryIcons[key] ?? Icons.circle, size: 16),
//           SizedBox(width: 8),
//           Text(key),
//         ],
//       );
//     }).toList();

//     return Wrap(
//       spacing: 16,
//       runSpacing: 16,
//       children: keys,
//     );
//   }

//   Widget buildCategoryPieChart(Map<String, double> categorySums) {
//     int touchedIndex = -1; // Use this to identify which segment is touched

//     // Function to determine the right color for each category
//     Color getCategoryColor(String category) {
//       switch (category) {
//         case 'Food':
//           return Colors.blue;
//         case 'Transport':
//           return Colors.purple;
//         case 'Shopping':
//           return Colors.red;
//         // Add more categories and colors as needed
//         default:
//           return Colors.greenAccent; // Default color for undefined categories
//       }
//     }

//     return PieChart(
//       PieChartData(
//         pieTouchData: PieTouchData(
//           touchCallback:
//               (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
//             setState(() {
//               if (!event.isInterestedForInteractions ||
//                   pieTouchResponse == null ||
//                   pieTouchResponse.touchedSection == null) {
//                 touchedIndex = -1;
//                 return;
//               }
//               touchedIndex =
//                   pieTouchResponse.touchedSection!.touchedSectionIndex;
//             });
//           },
//         ),
//         borderData: FlBorderData(show: false),
//         sectionsSpace:
//             0, // No space between sections to replicate the image design
//         centerSpaceRadius: 30, // Adjust the size of the center space (hole)
//         sections: categorySums.entries.map((entry) {
//           final index = categorySums.keys.toList().indexOf(entry.key);
//           final isTouched = index == touchedIndex;
//           final fontSize =
//               isTouched ? 18.0 : 14.0; // Increase font size when touched
//           final radius =
//               isTouched ? 110.0 : 100.0; // Increase radius when touched
//           final color =
//               getCategoryColor(entry.key); // Get color based on category

//           return PieChartSectionData(
//             color: color,
//             value: entry.value,
//             title: '${entry.key}\n${entry.value.toStringAsFixed(0)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//             ),
//             titlePositionPercentageOffset:
//                 0.55, // Positions the title inside the section
//             borderSide: BorderSide(
//                 color: color.withOpacity(0.1),
//                 width: isTouched ? 6 : 0), // Border side when touched
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
