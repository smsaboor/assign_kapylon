import 'package:assign_kapylon/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataHelper {
  static DataHelper? _databaseHelper; // Define Singleton DatabaseHelper object
  static Database? _database; // Define Singleton Database object

  DataHelper._createInstance();

  factory DataHelper() {
    _databaseHelper ??= DataHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}kapylon2.db';
    var assetDatabase = await openDatabase(path,
        version: 1,
        onCreate: _createDb,
        onUpgrade: _upgradeDb,
        onOpen: _openDb);
    return assetDatabase;
  }


  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE user(userId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, address TEXT NOT NULL, dob TEXT, imagePath TEXT)');
     }
  void _upgradeDb(Database db, int oldVersion, int newVersion) async {}
  void _openDb(Database db) async {}




  Future<List<Map<String, dynamic>>> getUserList() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT * FROM user');
    return result;
  }


  Future<int> insertUser(User user) async {
    debugPrint('User created in ${user.address}');
    Database db = await database;
    var result = await db.insert('user', user.toJson());
    if (result != 0) {
      debugPrint('User created in local DB');
    } else {
      debugPrint('Failed to create user in local DB');
    }
    return result;
  }

  Future<int> deleteUser(int id) async {
    var db = await database;
    int result = await db.rawDelete('DELETE FROM user WHERE userId = $id');
    return result;
  }
} // End of Class
