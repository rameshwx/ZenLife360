import 'package:flutter/material.dart';
import 'package:zenlife/database/dbhelper/meal_journal_db_helper.dart';

class JournalEntryy {
  int? entryId;
  int userId; // Make sure this exists
  String date;
  String content;
  bool deleteFlag;
  bool uploadFlag;
  DateTime? lastUpdated;

  JournalEntryy({
    this.entryId,
    required this.userId, // This needs to match the named parameter
    required this.date,
    required this.content,
    required this.deleteFlag,
    required this.uploadFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'entry_id': entryId,
      'user_id': userId,
      'date': date,
      'content': content,
      'delete_flag': deleteFlag ? 1 : 0,
      'upload_flag': uploadFlag ? 1 : 0,
      'last_updated': lastUpdated,
    };
  }

  Future<void> saveToDatabase() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insert(toMap(), 'journal_entries');
  }

  Future<void> updateInDatabase() async {
    if (entryId != null) {
      final dbHelper = DatabaseHelper();
      await dbHelper.update(toMap(), 'journal_entries');
    }
  }

  Future<void> deleteFromDatabase() async {
    if (entryId != null) {
      final dbHelper = DatabaseHelper();
      await dbHelper.delete(entryId!, 'journal_entries');
    }
  }
}
