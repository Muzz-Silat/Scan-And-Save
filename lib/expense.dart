class Expense {
  final double amount;
  final String description;
  final DateTime date;
  final String currency;
  final String category; // New category field

  Expense({
    required this.amount,
    required this.description,
    required this.date,
    required this.currency,
    required this.category, // Initialize in constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'description': description,
      'date': date,
      'currency': currency,
      'category': category, // Include in map
    };
  }
}
