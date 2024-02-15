import 'dart:async';
import 'dart:typed_data'; // For handling BLOB data type
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/prescription_model.dart'; // Ensure this model class is defined

class PrescriptionsDbHelper {
  static const tableName = 'Prescriptions';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const prescriptionIdColumn = 'prescription_id';
  static const userIdColumn = 'user_id';
  static const notesColumn = 'notes';
  static const prescImageColumn = 'presc_image'; // BLOB for storing images
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
        $prescriptionIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $userIdColumn INTEGER,
        $notesColumn TEXT,
        $prescImageColumn BLOB,
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

  static Future<int> insertPrescription(Prescription prescription) async {
    final db = await database;
    return await db.insert(tableName, prescription.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Prescription>> getAllPrescriptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Prescription.fromMap(maps[i]);
    });
  }

  static Future<int> updatePrescription(Prescription prescription) async {
    final db = await database;
    return await db.update(tableName, prescription.toMap(), where: '$prescriptionIdColumn = ?', whereArgs: [prescription.prescriptionId]);
  }

  static Future<int> deletePrescription(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$prescriptionIdColumn = ?', whereArgs: [id]);
  }
}
