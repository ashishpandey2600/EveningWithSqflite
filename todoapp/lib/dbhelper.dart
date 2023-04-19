import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
CREATE TABLE items(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  description TEXT,
  isdone BOOLEAN,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)

""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('dpan.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createItem(int isdone, String? description) async {
    final db = await SQLHelper.db();

    final data = {'isdone': isdone, 'description': description};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id=?", whereArgs: ['id'], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<int> updateItem(int id, int isdone, String description) async {
    final db = await SQLHelper.db();
    int count = await db
        .rawUpdate('UPDATE items SET isdone = ? WHERE id = ?', [isdone, id]);
    print('updated1: $id');

    // final data = {
    //   'isdone': isdone,
    //   'description': description,
    //   'createdAt': DateTime.now().toString()
    // };
    print("update called");
    // final result =
    //     await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return count;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("items", where: "id=?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
