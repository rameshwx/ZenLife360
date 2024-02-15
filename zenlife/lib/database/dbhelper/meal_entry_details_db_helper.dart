// File: meal_entry_details_db_helper.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/meal_entry_detail_model.dart'; // Ensure this model class is defined

class MealEntryDetailsDbHelper {
  static const tableName = 'MealEntryDetails';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const detailIdColumn = 'detail_id';
  static const entryIdColumn = 'entry_id';
  static const categoryIdColumn = 'category_id';
  static const quantityColumn = 'quantity';
  static const caloriesCalculatedColumn = 'calories_calculated';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await open();
    return _database!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $tableName (
        $detailIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $entryIdColumn INTEGER,
        $categoryIdColumn INTEGER,
        $quantityColumn INTEGER,
        $caloriesCalculatedColumn INTEGER,
        FOREIGN KEY ($entryIdColumn) REFERENCES UserMealEntries(entry_id),
        FOREIGN KEY ($categoryIdColumn) REFERENCES FoodCategories(category_id)
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertMealEntryDetail(MealEntryDetail detail) async {
    final db = await database;
    return await db.insert(tableName, detail.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<MealEntryDetail>> getAllMealEntryDetails() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return MealEntryDetail.fromMap(maps[i]);
    });
  }

  static Future<int> updateMealEntryDetail(MealEntryDetail detail) async {
    final db = await database;
    return await db.update(tableName, detail.toMap(), where: '$detailIdColumn = ?', whereArgs: [detail.detailId]);
  }

  static Future<int> deleteMealEntryDetail(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$detailIdColumn = ?', whereArgs: [id]);
  }
}
