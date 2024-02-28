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

  // You can add methods for fetching, updating, and deleting expenses as needed
}
