import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/user_meal_entry_model.dart'; // Ensure this model class is defined

class UserMealEntriesDbHelper {
  static const tableName = 'UserMealEntries';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const entryIdColumn = 'entry_id';
  static const userIdColumn = 'user_id';
  static const dateColumn = 'date';
  static const mealTypeColumn = 'meal_type';
  static const descriptionColumn = 'description';
  static const deleteFlagColumn = 'delete_flag';
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
        $dateColumn DATE NOT NULL,
        $mealTypeColumn TEXT NOT NULL,
        $descriptionColumn TEXT,
        $deleteFlagColumn BOOLEAN NOT NULL DEFAULT 0,
        $lastUpdatedColumn DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($userIdColumn) REFERENCES Users(user_id)
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertUserMealEntry(UserMealEntry entry) async {
    final db = await database;
    return await db.insert(tableName, entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<UserMealEntry>> getAllUserMealEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return UserMealEntry.fromMap(maps[i]);
    });
  }

  static Future<int> updateUserMealEntry(UserMealEntry entry) async {
    final db = await database;
    return await db.update(tableName, entry.toMap(), where: '$entryIdColumn = ?', whereArgs: [entry.entryId]);
  }

  static Future<int> deleteUserMealEntry(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$entryIdColumn = ?', whereArgs: [id]);
  }
}
