class MedicationTime {
  int? timeId;
  int? medicationId;
  String? takeTime; // Storing TIME as String, assuming format "HH:mm:ss"
  bool? deleteFlag;
  DateTime? lastUpdated;

  MedicationTime({
    this.timeId,
    this.medicationId,
    this.takeTime,
    this.deleteFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'time_id': timeId,
      'medication_id': medicationId,
      'take_time': takeTime,
      'delete_flag': deleteFlag ?? false ? 1 : 0,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static MedicationTime fromMap(Map<String, dynamic> map) {
    return MedicationTime(
      timeId: map['time_id'],
      medicationId: map['medication_id'],
      takeTime: map['take_time'],
      deleteFlag: map['delete_flag'] == 1,
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
