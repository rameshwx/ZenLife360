// File: food_categories_db_helper.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/food_category_model.dart'; // Ensure this model class is defined

class FoodCategoriesDbHelper {
  static const tableName = 'FoodCategories';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const categoryIdColumn = 'category_id';
  static const categoryNameColumn = 'category_name';
  static const caloriesPer100gColumn = 'calories_per_100g';
  static const caloriesPerCupColumn = 'calories_per_cup';
  static const servingDescriptionColumn = 'serving_description';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await open();
    return _database!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $tableName (
        $categoryIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $categoryNameColumn TEXT NOT NULL,
        $caloriesPer100gColumn INTEGER NOT NULL,
        $caloriesPerCupColumn INTEGER,
        $servingDescriptionColumn TEXT NOT NULL
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertFoodCategory(FoodCategory category) async {
    final db = await database;
    return await db.insert(tableName, category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<FoodCategory>> getAllFoodCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return FoodCategory.fromMap(maps[i]);
    });
  }

  static Future<int> updateFoodCategory(FoodCategory category) async {
    final db = await database;
    return await db.update(tableName, category.toMap(), where: '$categoryIdColumn = ?', whereArgs: [category.categoryId]);
  }

  static Future<int> deleteFoodCategory(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$categoryIdColumn = ?', whereArgs: [id]);
  }
}
