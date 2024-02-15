class ScheduledMedication {
  int? medicationId;
  int? scheduleId;
  String? medicationName;
  String? mealTime; // Assuming this could be "Morning", "Afternoon", "Evening", or specific times as strings
  bool? deleteFlag;
  DateTime? lastUpdated;

  ScheduledMedication({
    this.medicationId,
    this.scheduleId,
    this.medicationName,
    this.mealTime,
    this.deleteFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'medication_id': medicationId,
      'schedule_id': scheduleId,
      'medication_name': medicationName,
      'meal_time': mealTime,
      'delete_flag': deleteFlag ?? false ? 1 : 0,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static ScheduledMedication fromMap(Map<String, dynamic> map) {
    return ScheduledMedication(
      medicationId: map['medication_id'],
      scheduleId: map['schedule_id'],
      medicationName: map['medication_name'],
      mealTime: map['meal_time'],
      deleteFlag: map['delete_flag'] == 1,
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
