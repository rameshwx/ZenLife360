import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static late Database _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'MedicDB.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE food_categories (id INTEGER PRIMARY KEY, name TEXT, calories_per_100g INTEGER, calories_per_cup INTEGER, image TEXT)');
    });
  }

  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    final dbClient = await db;
    return await dbClient.insert(tableName, row);
  }

  Future<int> update(Map<String, dynamic> row, String tableName) async {
    final dbClient = await db;
    return await dbClient.update(tableName, row,
        where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    final dbClient = await db;
    return await dbClient.query(tableName);
  }

  Future<int> delete(int id, String tableName) async {
    final dbClient = await db;
    return await dbClient.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Functions for food categories
  Future<int> insertFoodCategory(Map<String, dynamic> row) async {
    final dbClient = await db;
    return await dbClient.insert('food_categories', row);
  }

  Future<List<Map<String, dynamic>>> queryAllFoodCategories() async {
    final dbClient = await db;
    return await dbClient.query('food_categories');
  }

  Future<int> deleteFoodCategory(int id) async {
    final dbClient = await db;
    return await dbClient
        .delete('food_categories', where: 'id = ?', whereArgs: [id]);
  }

  insertSelectedItems(List<Map<String, dynamic>> selectedItems, String string) {}

  querySelectedItems(String string) {}
}
