import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'expense.dart'; // Ensure this points to your Expense model
import 'dart:math' as math;
import 'firestore_service.dart'; // Ensure this points to your Firestore service

class AddExpensePage extends StatefulWidget {
  static const String routeName = '/addExpensePage';

  const AddExpensePage({Key? key}) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final FirestoreService _firestoreService = FirestoreService();
  List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AED'];
  String _selectedCurrency = 'USD'; // Default currency
  List<String> categories = [
    'Auto',
    'Groceries',
    'Dining Out',
    'Transport',
    'Entertainment',
    'Travel',
    'Education',
    'Clothing & Accessories',
    'Miscellaneous'
  ]; // Example categories
  String _selectedCategory = 'Miscellaneous'; // Default category

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String getCurrentMonthYear() {
    final DateTime now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  Future<String> categorizeExpenseWithChatGPT(String description) async {
    // Initialize your ChatGPT client
    final _openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
      enableLog: true,
    );

    // Construct your prompt for ChatGPT
    final prompt = "Categorize the following expense: $description. "
        "Categories: Groceries, Dining Out, Transport, Entertainment, Travel, Education, Clothing & Accessories, Miscellaneous."
        "Ensure the output is only one of the Categories";

    // Send the prompt to ChatGPT and wait for the response
    final response = await _openAI.onChatCompletion(
        request: ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [Messages(role: Role.user, content: prompt)],
      maxToken: 200,
    ));

    // Parse the response from ChatGPT to match one of your categories
    String categorizedResponse =
        response!.choices.first.message!.content.trim();

    return categorizedResponse.replaceAll(
        ".", ""); // This should be the matched category
  }

  void _submitExpense() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final expenseAmount = double.parse(_amountController.text);
        String expenseCategory = _selectedCategory;
        // Auto-categorize the expense if necessary
        if (expenseCategory == "Auto") {
          // Assume categorizeExpenseWithChatGPT is an async function you've defined
          expenseCategory =
              await categorizeExpenseWithChatGPT(_descriptionController.text);
        }

        // Fetch the current month's budget document
        String monthYear = getCurrentMonthYear();
        final monthlyBudgetDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Budgets')
            .doc(monthYear)
            .get();

        if (monthlyBudgetDoc.exists) {
          Map<String, dynamic> monthlyBudgetData = monthlyBudgetDoc.data()!;
          double newCategoryBudget =
              (monthlyBudgetData['categoryBudgets'][expenseCategory] ?? 0) -
                  expenseAmount;
          double newTotalBudget =
              (monthlyBudgetData['totalBudget'] ?? 0) - expenseAmount;

          newCategoryBudget =
              math.max(0, newCategoryBudget); // Ensure it doesn't go negative

          // Safely constructing the update map
          Map<String, dynamic> updateData = {'totalBudget': newTotalBudget};
          if (monthlyBudgetData['categoryBudgets'] != null &&
              monthlyBudgetData['categoryBudgets'] is Map) {
            (monthlyBudgetData['categoryBudgets'] as Map)[expenseCategory] =
                newCategoryBudget;
            updateData['categoryBudgets'] =
                monthlyBudgetData['categoryBudgets'];
          }

          // Update the Settings document with constructed update data
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('Preferences')
              .doc('Settings')
              .update(updateData);
        }

        // Proceed with adding the expense
        final expense = Expense(
          amount: expenseAmount,
          description: _descriptionController.text,
          date: _selectedDate,
          currency: _selectedCurrency,
          category: expenseCategory,
        );
        await _firestoreService.addExpense(user.uid, expense.toMap());

        // Reset form and show confirmation
        _formKey.currentState!.reset();
        setState(() {
          _selectedDate = DateTime.now();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense added successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  value: _selectedCurrency,
                  decoration: InputDecoration(labelText: 'Currency'),
                  items:
                      currencies.map<DropdownMenuItem<String>>((String value) {
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
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
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
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _pickDate(context),
                      tooltip: 'Pick Date',
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Selected date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitExpense,
                    child: Text('Submit Expense'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
