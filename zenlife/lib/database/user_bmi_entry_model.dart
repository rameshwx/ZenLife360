class UserBMIEntry {
  int? bmiEntryId;
  int? userId;
  double? weight;
  double? height;
  double? bmiValue;
  DateTime? entryDate;
  bool? deleteFlag;
  bool? uploadFlag;
  DateTime? lastUpdated;

  UserBMIEntry({
    this.bmiEntryId,
    this.userId,
    this.weight,
    this.height,
    this.bmiValue,
    this.entryDate,
    this.deleteFlag,
    this.uploadFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'bmi_entry_id': bmiEntryId,
      'user_id': userId,
      'weight': weight,
      'height': height,
      'bmi_value': bmiValue,
      'entry_date': entryDate?.toIso8601String(),
      'delete_flag': deleteFlag ?? false ? 1 : 0,
      'upload_flag': uploadFlag ?? false ? 1 : 0,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static UserBMIEntry fromMap(Map<String, dynamic> map) {
    return UserBMIEntry(
      bmiEntryId: map['bmi_entry_id'],
      userId: map['user_id'],
      weight: map['weight']?.toDouble(),
      height: map['height']?.toDouble(),
      bmiValue: map['bmi_value']?.toDouble(),
      entryDate: DateTime.tryParse(map['entry_date']),
      deleteFlag: map['delete_flag'] == 1,
      uploadFlag: map['upload_flag'] == 1,
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
