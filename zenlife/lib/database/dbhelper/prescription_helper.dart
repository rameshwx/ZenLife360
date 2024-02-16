// ignore_for_file: avoid_print, camel_case_types

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String prescriptionTable = 'prescription';
const String idColumn = 'id';
const String nameColumn = 'name';
const String imgColumn = 'img';
const String descriptionColumn ='description';

class prescriptionHelper {
  static final prescriptionHelper _instance = prescriptionHelper.internal();
  factory prescriptionHelper() => _instance;
  prescriptionHelper.internal();

  late Database _db;

  Future<Database> get db async {
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'healthdb.db');
    print('Database path: $path');

    _db = await openDatabase(path, version: 1,
        onCreate: (db, newerVersion) async {
      print('Creating database');
      await db.execute(
        'CREATE TABLE $prescriptionTable('
        '$idColumn INTEGER PRIMARY KEY,'
        '$nameColumn TEXT,'
        '$imgColumn TEXT,'
        '$descriptionColumn TEXT)', // Include description column
      );
    });

    print('Database created successfully');
    return _db;
  }

  Future<prescription> saveprescription(prescription contact) async {
    var healthdb = await db;
    contact.id = await healthdb.insert(prescriptionTable, contact.toMap());
    print('prescription saved: $contact');
    print('All prescription: ${await getAllprescription()}');
    return contact;
  }

  Future<prescription> getprescription(int id) async {
    var healthdb = await db;
    List<Map<String, dynamic>> maps = await healthdb.query(prescriptionTable,
        columns: [
          idColumn,
          nameColumn,
          imgColumn,
          descriptionColumn
        ], // Include description column
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return prescription.fromMap(maps.first);
    } else {
      return prescription(); // Return a default contact if not found
    }
  }

  Future<int> deleteprescription(int id) async {
    var healthdb = await db;
    return await healthdb
        .delete(prescriptionTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateprescription(prescription contact) async {
    var healthdb = await db;
    return await healthdb.update(prescriptionTable, contact.toMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);
  }

  Future<List<prescription>> getAllprescription() async {
    var healthdb = await db;
    List<Map<String, dynamic>> listMap =
        await healthdb.rawQuery('SELECT * FROM $prescriptionTable');
    var listprescription = <prescription>[];
    for (Map<String, dynamic> m in listMap) {
      listprescription.add(prescription.fromMap(m));
    }

    print('All Contacts: $listprescription');
    return listprescription;
  }

  Future<int?> getNumber() async {
    var healthdb = await db;
    return Sqflite.firstIntValue(
        await healthdb.rawQuery('SELECT COUNT(*) FROM $prescriptionTable'));
  }

  Future close() async {
    var healthdb = await db;
    healthdb.close();
  }
}

class prescription {
  int? id;
  String? name;
  String? img;
  String? description; // New property for description

  prescription();

  prescription.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    name = map[nameColumn];
    img = map[imgColumn];
    description = map[descriptionColumn]; // Initialize description
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      nameColumn: name,
      imgColumn: img,
      descriptionColumn: description // Include description in the map
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'prescription('
        'id: $id,'
        'name: $name, '
        'img: $img, '
        'description: $description)'; // Include description in the string representation
  }
}
