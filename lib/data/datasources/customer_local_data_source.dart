import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

import '../../core/error/exceptions.dart';
import '../models/customer_model.dart';

abstract class CustomerLocalDataSource {
  Future<void> saveEntries(List<CustomerModel> entries);

  Future<List<Map<String, dynamic>>> getSavedDates();

  Future<List<CustomerModel>> getEntriesForDate(DateTime date);

  Future<List<CustomerModel>> getAllCustomers(); // New method
  Future<void> addCustomer(CustomerModel customer); // New method
  Future<void> editCustomer(CustomerModel customer); // New method
  Future<void> deleteCustomer(int id); // New method
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'udhari_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE customer_entries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          quantity INTEGER,
          date TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE customers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE
        )
      ''');
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getSavedDates() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT DISTINCT date FROM customer_entries ORDER BY date DESC',
      );
      return maps;
    } on DatabaseException {
      throw DatabaseException();
    }
  }

  @override
  Future<void> saveEntries(List<CustomerModel> entries) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.delete(
          'customer_entries',
          where: 'date = ?',
          whereArgs: [entries.first.date.toIso8601String()],
        );
        for (var entry in entries) {
          await txn.insert(
            'customer_entries',
            entry.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      throw DatabaseException();
    }
  }

  @override
  Future<List<CustomerModel>> getEntriesForDate(DateTime date) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'customer_entries',
        where: 'date = ?',
        whereArgs: [
          date.toIso8601String().substring(0, 10),
        ], // Fetch entries for a specific day
      );
      return maps.map((map) => CustomerModel.fromMap(map)).toList();
    } on DatabaseException {
      throw DatabaseException();
    }
  }

  // New methods
  @override
  Future<void> addCustomer(CustomerModel customer) async {
    final db = await database;
    await db.insert('customers', {
      'name': customer.name,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> editCustomer(CustomerModel customer) async {
    final db = await database;
    await db.update(
      'customers',
      {'name': customer.name},
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  @override
  Future<void> deleteCustomer(int id) async {
    final db = await database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return maps
        .map(
          (map) => CustomerModel(
            id: map['id'],
            name: map['name'],
            quantity: 0,
            date: DateTime.now(),
          ),
        )
        .toList();
  }
}
