// File: scheduled_medications_db_helper.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/scheduled_medication_model.dart'; // Ensure you have this model defined

class ScheduledMedicationsDbHelper {
  static const tableName = 'ScheduledMedications';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const medicationIdColumn = 'medication_id';
  static const scheduleIdColumn = 'schedule_id';
  static const medicationNameColumn = 'medication_name';
  static const mealTimeColumn = 'meal_time';
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
        $medicationIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $scheduleIdColumn INTEGER,
        $medicationNameColumn TEXT NOT NULL,
        $mealTimeColumn TEXT,
        $deleteFlagColumn BOOLEAN NOT NULL DEFAULT 0,
        $lastUpdatedColumn DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($scheduleIdColumn) REFERENCES MedicationSchedules(schedule_id)
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertScheduledMedication(ScheduledMedication medication) async {
    final db = await database;
    return await db.insert(tableName, medication.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ScheduledMedication>> getAllScheduledMedications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return ScheduledMedication.fromMap(maps[i]);
    });
  }

  static Future<int> updateScheduledMedication(ScheduledMedication medication) async {
    final db = await database;
    return await db.update(tableName, medication.toMap(), where: '$medicationIdColumn = ?', whereArgs: [medication.medicationId]);
  }

  static Future<int> deleteScheduledMedication(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$medicationIdColumn = ?', whereArgs: [id]);
  }
}
