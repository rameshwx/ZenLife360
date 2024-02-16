import 'dart:async';
import 'dart:typed_data'; // For BLOB handling
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:zenlife/database/health_article_model.dart'; // Assuming you have this model class

class HealthArticlesDbHelper {
  static const tableName = 'HealthArticles';
  static const databaseName = 'MedicDB.db';
  static const databaseVersion = 1;

  static const articleIdColumn = 'article_id';
  static const titleColumn = 'title';
  static const descriptionColumn = 'description';
  static const imageFileColumn = 'image_file';
  static const publishedDateColumn = 'published_date';
  static const lastUpdatedColumn = 'last_updated';
  static const deleteFlagColumn = 'delete_flag';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await open();
    return _database!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $tableName (
        $articleIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $titleColumn TEXT NOT NULL,
        $descriptionColumn TEXT NOT NULL,
        $imageFileColumn BLOB,
        $publishedDateColumn DATETIME NOT NULL,
        $lastUpdatedColumn DATETIME DEFAULT CURRENT_TIMESTAMP,
        $deleteFlagColumn BOOLEAN NOT NULL DEFAULT 0
      )""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, databaseName);
    return await openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future<int> insertArticle(HealthArticle article) async {
    final db = await database;
    return await db.insert(tableName, article.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<HealthArticle>> getAllArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return HealthArticle.fromMap(maps[i]);
    });
  }

  static Future<int> updateArticle(HealthArticle article) async {
    final db = await database;
    return await db.update(tableName, article.toMap(), where: '$articleIdColumn = ?', whereArgs: [article.articleId]);
  }

  static Future<int> deleteArticle(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$articleIdColumn = ?', whereArgs: [id]);
  }

  Future<HealthArticle?> getArticleById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$articleIdColumn = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return HealthArticle.fromMap(maps.first);
    }
    return null;
  }
}
