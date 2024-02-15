import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/medication_schedule_model.dart'; // Ensure you have this model defined

class MedicationSchedulesDbHelper {
  static const tableName = 'MedicationSchedules';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const scheduleIdColumn = 'schedule_id';
  static const userIdColumn = 'user_id';
  static const scheduleNameColumn = 'schedule_name';
  static const startDateColumn = 'start_date';
  static const durationDaysColumn = 'duration_days';
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
        $scheduleIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $userIdColumn INTEGER,
        $scheduleNameColumn TEXT NOT NULL,
        $startDateColumn DATE NOT NULL,
        $durationDaysColumn INTEGER NOT NULL,
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

  static Future<int> insertMedicationSchedule(MedicationSchedule schedule) async {
    final db = await database;
    return await db.insert(tableName, schedule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<MedicationSchedule>> getAllMedicationSchedules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return MedicationSchedule.fromMap(maps[i]);
    });
  }

  static Future<int> updateMedicationSchedule(MedicationSchedule schedule) async {
    final db = await database;
    return await db.update(tableName, schedule.toMap(), where: '$scheduleIdColumn = ?', whereArgs: [schedule.scheduleId]);
  }

  static Future<int> deleteMedicationSchedule(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$scheduleIdColumn = ?', whereArgs: [id]);
  }
}
