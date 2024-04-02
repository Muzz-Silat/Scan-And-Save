class MonthlyBudget {
  final double totalBudget;
  final double savings;
  final Map<String, double> categoryBudgets;
  // Add more fields as necessary

  MonthlyBudget({
    required this.totalBudget,
    required this.savings,
    required this.categoryBudgets,
  });

  // Method to convert a MonthlyBudget object into a Map
  Map<String, dynamic> toMap() {
    return {
      'totalBudget': totalBudget,
      'savings': savings,
      'categoryBudgets': categoryBudgets,
    };
  }

  // Method to create a MonthlyBudget object from a Map
  static MonthlyBudget fromMap(Map<String, dynamic> map) {
    return MonthlyBudget(
      totalBudget: map['totalBudget'],
      savings: map['savings'],
      categoryBudgets: Map<String, double>.from(map['categoryBudgets']),
    );
  }
}
