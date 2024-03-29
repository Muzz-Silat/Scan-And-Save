class UserPreferences {
  final String preferredCurrency;

  UserPreferences({this.preferredCurrency = 'USD'});

  Map<String, dynamic> toMap() {
    return {
      'preferredCurrency': preferredCurrency,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      preferredCurrency: map['preferredCurrency'] ?? 'USD',
    );
  }
}
