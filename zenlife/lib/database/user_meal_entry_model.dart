class UserMealEntry {
  int? entryId;
  int? userId;
  DateTime? date;
  String? mealType;
  String? description;
  bool? deleteFlag;
  DateTime? lastUpdated;

  UserMealEntry({
    this.entryId,
    this.userId,
    this.date,
    this.mealType,
    this.description,
    this.deleteFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'entry_id': entryId,
      'user_id': userId,
      'date': date?.toIso8601String(), // Convert DateTime to a string format
      'meal_type': mealType,
      'description': description,
      'delete_flag': deleteFlag ?? false ? 1 : 0, // Convert bool to int
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static UserMealEntry fromMap(Map<String, dynamic> map) {
    return UserMealEntry(
      entryId: map['entry_id'],
      userId: map['user_id'],
      date: DateTime.tryParse(map['date']), // Parse string back to DateTime
      mealType: map['meal_type'],
      description: map['description'],
      deleteFlag: map['delete_flag'] == 1, // Convert int back to bool
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
