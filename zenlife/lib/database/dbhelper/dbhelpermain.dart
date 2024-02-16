import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "MedicDB.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {


    await db.execute('''
    CREATE TABLE Prescriptions (
      prescription_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      notes TEXT,
      presc_image BLOB,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE JournalEntries (
      entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      date DATETIME NOT NULL,
      content TEXT NOT NULL,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      upload_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE FoodCategories (
      category_id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_name TEXT NOT NULL,
      calories_per_100g INTEGER NOT NULL,
      calories_per_cup INTEGER,
      serving_description TEXT NOT NULL
    )
  ''');

    await db.execute(
        'CREATE TABLE food_categories ('
            'id INTEGER PRIMARY KEY, name TEXT, '
            'calories_per_100g INTEGER, '
            'calories_per_cup INTEGER, image TEXT)');

    await db.execute('''
    CREATE TABLE prescription (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      name TEXT,
      img TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE UserMealEntries (
      entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      date DATE NOT NULL,
      meal_type TEXT NOT NULL,
      description TEXT,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE MealEntryDetails (
      detail_id INTEGER PRIMARY KEY AUTOINCREMENT,
      entry_id INTEGER,
      category_id INTEGER,
      quantity INTEGER,
      calories_calculated INTEGER,
      FOREIGN KEY (entry_id) REFERENCES UserMealEntries(entry_id),
      FOREIGN KEY (category_id) REFERENCES FoodCategories(category_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE MedicationSchedules (
      schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      schedule_name TEXT NOT NULL,
      start_date DATE NOT NULL,
      duration_days INTEGER NOT NULL,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE ScheduledMedications (
      medication_id INTEGER PRIMARY KEY AUTOINCREMENT,
      schedule_id INTEGER,
      medication_name TEXT NOT NULL,
      meal_time TEXT,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (schedule_id) REFERENCES MedicationSchedules(schedule_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE MedicationTimes (
      time_id INTEGER PRIMARY KEY AUTOINCREMENT,
      medication_id INTEGER,
      take_time TIME NOT NULL,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (medication_id) REFERENCES ScheduledMedications(medication_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE UserBMIEntries (
      bmi_entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      weight DECIMAL NOT NULL,
      height DECIMAL NOT NULL,
      bmi_value DECIMAL NOT NULL,
      entry_date DATE NOT NULL,
      delete_flag BOOLEAN NOT NULL DEFAULT 0,
      upload_flag BOOLEAN NOT NULL DEFAULT 0,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');

    await db.execute('''
    CREATE TABLE HealthArticles (
      article_id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      image_file BLOB,
      published_date DATETIME NOT NULL,
      last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
      delete_flag BOOLEAN NOT NULL DEFAULT 0
    )
  ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
