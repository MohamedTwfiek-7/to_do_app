import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = '${await getDatabasesPath()}task.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING , note TEXT, date STRING,'
              'startTime STRING, endTime STRING,'
              'remind INTEGER, repeat STRING,'
              'color INTEGER,'
              'isCompleted INTEGER)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insertTask(Task task) async {
    print('--------------------------------------------insert called');
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<int> deleteTask(Task task) async {
    print('--------------------------------------------delete called');

    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    print('--------------------------------------------delete All called');

    return await _db!.delete(_tableName);
  }

  static Future<int> updateTask(int id) async {
    print('--------------------------------------------update called');

    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
   
    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('---------------------------------------------query called');

    return await _db!.query(_tableName);
  }
}
