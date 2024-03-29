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
        "Ensure the total budget is less than the monthly income minus the savings goal and is based on the proportional spending of last month's expenses. Also Ensure that none of the categories have value of 0 allocated";

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [Messages(role: Role.user, content: prompt)],
      maxToken: 200,
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      setState(() {
        budgetAdvice = response!.choices.first.message!.content.trim();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Budget Plan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _monthlyIncomeController,
                decoration:
                    const InputDecoration(labelText: 'Monthly Income (\$)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _savingsGoalController,
                decoration:
                    const InputDecoration(labelText: 'Savings Goal (\$)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: generateBudgetPlan,
                      child: const Text('Generate Budget Plan'),
                    ),
              SizedBox(height: 20),
              Text(
                budgetAdvice,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              // Save Budget Button
              if (!isLoading &&
                  budgetAdvice !=
                      "Your budget breakdown will be displayed here.") // Check if the budget plan has been generated
                ElevatedButton(
                  onPressed: () async {
                    // Extract the total budget value from the response
                    RegExp regex = RegExp(r"Budget: \$([\d\.]+)");
                    var matches = regex.firstMatch(budgetAdvice);
                    if (matches != null && matches.groupCount >= 1) {
                      double budgetValue = double.parse(matches.group(1)!);
                      await saveBudgetToFirestore(budgetValue);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Budget saved successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to extract budget value')),
                      );
                    }
                  },
                  child: const Text('Save Budget to Firestore'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveBudgetToFirestore(double budgetValue) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      await firestore.collection('Users').doc(user.uid).set({
        'totalBudget': budgetValue,
      }, SetOptions(merge: true));
      print('Budget saved: $budgetValue');
    }
  }
}
