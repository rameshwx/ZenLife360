import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/medication_time_model.dart'; 

class MedicationTimesDbHelper {
  static const tableName = 'MedicationTimes';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const timeIdColumn = 'time_id';
  static const medicationIdColumn = 'medication_id';
  static const takeTimeColumn = 'take_time';
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
        $timeIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $medicationIdColumn INTEGER,
        $takeTimeColumn TIME NOT NULL,
        $deleteFlagColumn BOOLEAN NOT NULL DEFAULT 0,
        $lastUpdatedColumn DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($medicationIdColumn) REFERENCES ScheduledMedications(medication_id)
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertMedicationTime(MedicationTime medicationTime) async {
    final db = await database;
    return await db.insert(tableName, medicationTime.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<MedicationTime>> getAllMedicationTimes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return MedicationTime.fromMap(maps[i]);
    });
  }

  static Future<int> updateMedicationTime(MedicationTime medicationTime) async {
    final db = await database;
    return await db.update(tableName, medicationTime.toMap(), where: '$timeIdColumn = ?', whereArgs: [medicationTime.timeId]);
  }

  static Future<int> deleteMedicationTime(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$timeIdColumn = ?', whereArgs: [id]);
  }
}
