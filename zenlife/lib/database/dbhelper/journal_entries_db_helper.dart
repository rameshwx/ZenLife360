// File: journal_entries_db_helper.dart

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/journal_entry_model.dart'; // Ensure this model class is defined

class JournalEntriesDbHelper {
  static const tableName = 'JournalEntries';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const entryIdColumn = 'entry_id';
  static const userIdColumn = 'user_id';
  static const dateColumn = 'date';
  static const contentColumn = 'content';
  static const deleteFlagColumn = 'delete_flag';
  static const uploadFlagColumn = 'upload_flag';
  static const lastUpdatedColumn = 'last_updated';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await open();
    return _database!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $tableName (
        $entryIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $userIdColumn INTEGER,
        $dateColumn DATETIME NOT NULL,
        $contentColumn TEXT NOT NULL,
        $deleteFlagColumn BOOLEAN NOT NULL DEFAULT 0,
        $uploadFlagColumn BOOLEAN NOT NULL DEFAULT 0,
        $lastUpdatedColumn DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($userIdColumn) REFERENCES Users(user_id)
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    return await db.insert('JournalEntries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateJournalEntry(JournalEntry entry) async {
    final db = await database;
    return await db.update(
      'JournalEntries',
      entry.toMap(),
      where: 'entry_id = ?',
      whereArgs: [entry.entryId],
    );
  }

  // static Future<int> insertJournalEntry(JournalEntry entry) async {
  //   final db = await database;
  //   return await db.insert(tableName, entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  static Future<List<JournalEntry>> getAllJournalEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return JournalEntry.fromMap(maps[i]);
    });
  }

  // static Future<int> updateJournalEntry(JournalEntry entry) async {
  //   final db = await database;
  //   return await db.update(tableName, entry.toMap(), where: '$entryIdColumn = ?', whereArgs: [entry.entryId]);
  // }

  static Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$entryIdColumn = ?', whereArgs: [id]);
  }

  Future<JournalEntry?> getEntryByDate(DateTime date) async {
    final db = await database;
    String dateString = DateFormat('yyyy-MM-dd').format(date); // Format date to string

    List<Map> maps = await db.query(
      'JournalEntries',
      where: 'date = ?',
      whereArgs: [dateString],
    );

    if (maps.isNotEmpty) {
      return JournalEntry.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }




}
