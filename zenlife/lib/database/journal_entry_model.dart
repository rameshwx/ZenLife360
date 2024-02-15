class JournalEntry {
  int? entryId;
  int? userId;
  DateTime? date;
  String? content;
  bool? deleteFlag;
  bool? uploadFlag;
  DateTime? lastUpdated;

  JournalEntry({
    this.entryId,
    this.userId,
    this.date,
    this.content,
    this.deleteFlag,
    this.uploadFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'entry_id': entryId,
      'user_id': userId,
      'date': date?.toIso8601String(), // Convert DateTime to a string format
      'content': content,
      'delete_flag': deleteFlag ?? false ? 1 : 0, // Convert bool to int for SQLite
      'upload_flag': uploadFlag ?? false ? 1 : 0,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static JournalEntry fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      entryId: map['entry_id'],
      userId: map['user_id'],
      date: DateTime.tryParse(map['date']), // Parse string back to DateTime
      content: map['content'],
      deleteFlag: map['delete_flag'] == 1, // Convert int back to bool
      uploadFlag: map['upload_flag'] == 1,
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
