import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addExpense(
      String userId, Map<String, dynamic> expenseData) async {
    await _db
        .collection('Users')
        .doc(userId)
        .collection('Expenses')
        .add(expenseData);
  }

  Future<Map<String, dynamic>> getExpenseDetails(
      String userId, String expenseId) async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Expenses')
        .doc(expenseId)
        .get();
    return doc.data() ?? {};
  }

  Future<void> updateExpense(
      String userId, String expenseId, Map<String, dynamic> expenseData) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Expenses')
        .doc(expenseId)
        .update(expenseData);
  }

  // You can add methods for fetching, updating, and deleting expenses as needed
}
