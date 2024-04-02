// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class SmartBudgetPage extends StatefulWidget {
//   @override
//   _SmartBudgetPageState createState() => _SmartBudgetPageState();
// }

// class _SmartBudgetPageState extends State<SmartBudgetPage> {
//   final TextEditingController _savingsGoalController = TextEditingController();
//   Map<String, double> categoryTotals = {};
//   String generatedPrompt = "";
//   double savingsGoal = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     categoryTotals = initializeCategoryTotals();
//     fetchAndAggregateExpenses();
//   }

//   Map<String, double> initializeCategoryTotals() {
//     const List<String> allCategories = [
//       'Groceries',
//       'Dining Out',
//       'Transport',
//       'Entertainment',
//       'Travel',
//       'Education',
//       'Clothing & Accessories',
//       'Miscellaneous',
//     ];
//     Map<String, double> categoryTotals = {};
//     for (String category in allCategories) {
//       categoryTotals[category] = 0.0;
//     }
//     return categoryTotals;
//   }

//   Future<void> fetchAndAggregateExpenses() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     final DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .collection('Expenses')
//           .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo)
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         for (var doc in querySnapshot.docs) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           String category = data['category'] ?? 'Miscellaneous';
//           double amount = data['amount'] ?? 0.0;

//           if (categoryTotals.containsKey(category)) {
//             categoryTotals[category] = categoryTotals[category]! + amount;
//           } else {
//             categoryTotals[category] = amount;
//           }
//         }

//         setState(() {
//           // Only update the prompt if a savings goal has already been set
//           if (savingsGoal > 0) {
//             generatedPrompt = generateGptPrompt(categoryTotals, savingsGoal);
//           }
//         });
//       });
//     }
//   }

//   String generateGptPrompt(
//       Map<String, double> categoryTotals, double savingsGoal) {
//     String prompt =
//         "Given the monthly spending in various categories and a savings goal, provide a detailed monthly budget plan. The user's spending in categories and their savings goal for the month are as follows:\n\n";

//     categoryTotals.forEach((category, amount) {
//       prompt += "- $category: \$$amount\n";
//     });

//     prompt += "\nMonthly Savings Goal: \$$savingsGoal\n\n";
//     prompt +=
//         "Generate a budget that aims to meet the savings goal, with advice on where to cut spending or reallocate funds. Include specific amounts to adjust in each category to reach the goal.";

//     return prompt;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Smart Budget'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _savingsGoalController,
//                 decoration:
//                     InputDecoration(labelText: 'Enter your savings goal'),
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     savingsGoal =
//                         double.tryParse(_savingsGoalController.text) ?? 0.0;
//                     generatedPrompt = generateGptPrompt(
//                         categoryTotals, savingsGoal); // Regenerate the prompt
//                   });
//                 },
//                 child: Text('Set Savings Goal'),
//               ),
//               ListView(
//                 children: categoryTotals.entries.map((entry) {
//                   return ListTile(
//                     leading: Icon(Icons
//                         .monetization_on), // Example icon, adjust as needed
//                     title: Text(entry.key),
//                     trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
//                   );
//                 }).toList(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20.0),
//                 child: Text(
//                   generatedPrompt.isNotEmpty
//                       ? generatedPrompt
//                       : 'Please set a savings goal to generate advice.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _savingsGoalController.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

// class SmartBudgetPage extends StatefulWidget {
//   const SmartBudgetPage({Key? key}) : super(key: key);

//   @override
//   _SmartBudgetPageState createState() => _SmartBudgetPageState();
// }

// class _SmartBudgetPageState extends State<SmartBudgetPage> {
//   String budgetAdvice = "Press the button below to generate budget advice.";
//   bool isLoading = false;
//   final _openAI = OpenAI.instance.build(
//     token: "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",
//     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
//     enableLog: true,
//   );

//   Future<void> generateBudgetAdvice() async {
//     setState(() {
//       isLoading = true;
//     });

//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final User? user = auth.currentUser;

//     if (user != null) {
//       final expensesSnapshot = await firestore
//           .collection('Users')
//           .doc(user.uid)
//           .collection('Expenses')
//           .get();

//       final expensesList = expensesSnapshot.docs
//           .map((doc) => "${doc['category']}: ${doc['amount']}")
//           .join(', ');

//       if (expensesList.isEmpty) {
//         setState(() {
//           budgetAdvice =
//               "No expenses found. Start adding your expenses to get advice.";
//           isLoading = false;
//         });
//         return;
//       }

//       final prompt =
//           "Given these expenses [$expensesList], provide some budgeting advice.";
//       final request = ChatCompleteText(
//         model: GptTurbo0301ChatModel(),
//         messages: [Messages(role: Role.user, content: prompt)],
//         maxToken: 200,
//       );

//       try {
//         final response = await _openAI.onChatCompletion(request: request);
//         setState(() {
//           budgetAdvice = response!.choices.first.message!.content.trim();
//           isLoading = false;
//         });
//       } catch (e) {
//         setState(() {
//           budgetAdvice =
//               "Failed to load budget advice. Please try again later.";
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         budgetAdvice = "Please log in to get budget advice.";
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Smart Budget Advice'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         // Wrap with SingleChildScrollView
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   budgetAdvice,
//                   style: TextStyle(fontSize: 18),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: generateBudgetAdvice,
//                 child: Text('Generate Budget Advice'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class SmartBudgetPage extends StatefulWidget {
  const SmartBudgetPage({Key? key}) : super(key: key);

  @override
  State<SmartBudgetPage> createState() => _SmartBudgetPageState();
}

class _SmartBudgetPageState extends State<SmartBudgetPage> {
  final TextEditingController _monthlyIncomeController =
      TextEditingController();
  final TextEditingController _savingsGoalController = TextEditingController();
  String budgetAdvice = "Your budget breakdown will be displayed here.";
  bool isLoading = false;
  double totalBudget = 0;
  double savings = 0;
  Map<String, double> categoryBudgets = {};
  final List<String> categories = [
    'Groceries',
    'Dining Out',
    'Transport',
    'Entertainment',
    'Travel',
    'Education',
    'Clothing & Accessories',
    'Miscellaneous'
  ];

  final _openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  Future<void> generateBudgetPlan() async {
    setState(() {
      isLoading = true;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      setState(() {
        budgetAdvice = "Please log in to generate your budget plan.";
        isLoading = false;
      });
      return;
    }

    // Fetch last month's expenses
    DateTime now = DateTime.now();
    DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 0);
    final expensesSnapshot = await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Expenses')
        .where('date', isGreaterThanOrEqualTo: firstDayOfLastMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfLastMonth)
        .get();

    String expenseDetails = expensesSnapshot.docs
        .map((doc) => '${doc['category']}: \$${doc['amount']}')
        .join(', ');

    // Adjusted prompt for GPT
    final prompt =
        "Given a monthly income of \$${_monthlyIncomeController.text}, "
        "a savings goal of \$${_savingsGoalController.text}, and detailed previous month's expenses as follows: $expenseDetails, "
        "allocate the remaining budget after subtracting the savings goal from the monthly income across the following categories: ${categories.join(', ')}. "
        "Ensure the output is in this format, without including anything else - Budget: TotalValue, Groceries: Value, Dining Out: Value, Transport: Value, Entertainment: Value, Travel: Value, Education: Value, Clothing & Accessories: Value, Miscellaneous: Value, Savings: Value"
        "Ensure the total budget is less than the monthly income minus the savings goal. Ensure each Category has a value of greater than 0, and uses previous month's expense to provide values for each category. If prevous month's expense is empty then provide based off normal spending";

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [Messages(role: Role.user, content: prompt)],
      maxToken: 200,
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      String budgetAdviceResponse =
          response!.choices.first.message!.content.trim();

      // Define a pattern that matches each category and its corresponding value
      RegExp regExp = RegExp(r'(\w[\w &]*): \$(\d+)');

      // Use RegExp to find all matches
      var matches = regExp.allMatches(budgetAdviceResponse);
      Map<String, double> localCategoryBudgets = {};

      // Loop through all matches and add them to the map
      for (var match in matches) {
        String category = match.group(1)!; // This is the category name
        double value = double.parse(match.group(2)!); // This is the value

        // Save them to a map
        localCategoryBudgets[category] = value;
      }
      double localSavingsGoal =
          double.tryParse(_savingsGoalController.text) ?? 0.0;
      double localMonthlyIncome =
          double.tryParse(_monthlyIncomeController.text) ?? 0.0;
      setState(() {
        budgetAdvice = response!.choices.first.message!.content.trim();
        totalBudget = localMonthlyIncome - localSavingsGoal;
        savings = localSavingsGoal;
        categoryBudgets = localCategoryBudgets;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        budgetAdvice =
            "Failed to generate budget plan. Please try again later.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    categoryBudgets = Map.from(categoryBudgets)..remove("Savings");
    categoryBudgets = Map.from(categoryBudgets)..remove("Budget");
    double monthlyIncome =
        double.tryParse(_monthlyIncomeController.text) ?? 0.0;
    double totalCategoryBudgets =
        categoryBudgets.values.fold(0, (sum, element) => sum + element);
    savings = monthlyIncome - totalCategoryBudgets;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Budget Plan'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _monthlyIncomeController,
                      decoration: const InputDecoration(
                          labelText: 'Monthly Income (\$)'),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _savingsGoalController,
                      decoration:
                          const InputDecoration(labelText: 'Savings Goal (\$)'),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: generateBudgetPlan,
                      child: const Text('Generate Budget Plan'),
                    ),
                    const SizedBox(height: 20),
                    ...categoryBudgets.entries.map((entry) => BudgetSlider(
                          category: entry.key,
                          budgetValue: entry.value,
                          onChanged: (newValue) {
                            double tempTotal = totalCategoryBudgets -
                                categoryBudgets[entry.key]! +
                                newValue;
                            if (monthlyIncome < tempTotal) {
                              // Show error message if total budget exceeds monthly income
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Total budget cannot exceed monthly income.")),
                              );
                              return; // Prevent state update
                            }

                            setState(() {
                              categoryBudgets[entry.key] = newValue;
                              // Recalculate total budget and savings
                              totalCategoryBudgets = categoryBudgets.values
                                  .fold(0, (sum, element) => sum + element);
                              savings = monthlyIncome - totalCategoryBudgets;
                              totalBudget = monthlyIncome - savings;
                            });
                          },
                        )),
                    Text(
                      'Total Budget: \$${totalCategoryBudgets.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Savings: \$${savings.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (savings < 0) {
                          // Additional check before saving to Firestore
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Cannot save: Total budget exceeds monthly income.")),
                          );
                          return;
                        }
                        await saveBudgetToFirestore();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Budget saved successfully')),
                        );
                      },
                      child: const Text('Save Budget to Firestore'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> saveBudgetToFirestore() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      // Identify the document ID for the current month and year
      String monthYear = getCurrentMonthYear();
      double updatedTotalBudget =
          categoryBudgets.values.fold(0, (sum, element) => sum + element);

      // Structure the data for monthly budget tracking
      Map<String, dynamic> monthlyBudgetData = {
        'totalBudget': updatedTotalBudget,
        'savings': savings,
        'categoryBudgets': categoryBudgets,
        // Include 'monthlyIncome' if needed
        'monthlyIncome': _monthlyIncomeController.text.isNotEmpty
            ? double.parse(_monthlyIncomeController.text)
            : 0,
      };

      // Save the structured data to the 'Budgets' collection, under a document named after the current month and year
      await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Budgets')
          .doc(monthYear)
          .set(monthlyBudgetData, SetOptions(merge: true));
      await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Preferences')
          .doc('Settings')
          .set(monthlyBudgetData, SetOptions(merge: true));

      print('Monthly budget for $monthYear saved: $updatedTotalBudget');
    }
  }
}

String getCurrentMonthYear() {
  final DateTime now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}";
}

class BudgetSlider extends StatelessWidget {
  final String category;
  final double budgetValue;
  final ValueChanged<double> onChanged;

  const BudgetSlider({
    Key? key,
    required this.category,
    required this.budgetValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$category: \$${budgetValue.toStringAsFixed(2)}'),
        Slider(
          value: budgetValue,
          min: 0,
          max: 1000, // Adjust the max value based on your application's needs
          divisions: 100,
          label: budgetValue.toStringAsFixed(2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
