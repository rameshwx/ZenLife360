import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/user_bmi_entry_model.dart'; // Assuming you have this model class defined similarly

class UserBMIDbHelper {
  static const tableName = 'UserBMIEntries';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const bmiEntryIdColumn = 'bmi_entry_id';
  static const userIdColumn = 'user_id';
  static const weightColumn = 'weight';
  static const heightColumn = 'height';
  static const bmiValueColumn = 'bmi_value';
  static const entryDateColumn = 'entry_date';
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
        $bmiEntryIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $userIdColumn INTEGER,
        $weightColumn DECIMAL NOT NULL,
        $heightColumn DECIMAL NOT NULL,
        $bmiValueColumn DECIMAL NOT NULL,
        $entryDateColumn DATE NOT NULL,
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

  static Future<int> insertBMIEntry(UserBMIEntry entry) async {
    final db = await database;
    return await db.insert(tableName, entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<UserBMIEntry>> getAllBMIEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return UserBMIEntry.fromMap(maps[i]);
    });
  }

  static Future<int> updateBMIEntry(UserBMIEntry entry) async {
    final db = await database;
    return await db.update(tableName, entry.toMap(), where: '$bmiEntryIdColumn = ?', whereArgs: [entry.bmiEntryId]);
  }

  static Future<int> deleteBMIEntry(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$bmiEntryIdColumn = ?', whereArgs: [id]);
  }
}
