class MedicationSchedule {
  int? scheduleId;
  int? userId;
  String? scheduleName;
  DateTime? startDate;
  int? durationDays;
  bool? deleteFlag;
  DateTime? lastUpdated;

  MedicationSchedule({
    this.scheduleId,
    this.userId,
    this.scheduleName,
    this.startDate,
    this.durationDays,
    this.deleteFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'schedule_id': scheduleId,
      'user_id': userId,
      'schedule_name': scheduleName,
      'start_date': startDate?.toIso8601String(),
      'duration_days': durationDays,
      'delete_flag': deleteFlag ?? false ? 1 : 0,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static MedicationSchedule fromMap(Map<String, dynamic> map) {
    return MedicationSchedule(
      scheduleId: map['schedule_id'],
      userId: map['user_id'],
      scheduleName: map['schedule_name'],
      startDate: DateTime.tryParse(map['start_date']),
      durationDays: map['duration_days'],
      deleteFlag: map['delete_flag'] == 1,
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
