import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/Models/Task.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colType = 'type';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'tasks.db';

    // Open/create the database at a given path
    var tasksDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return tasksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colType INTEGER DEFAULT 1)');
  }

  // Fetch Operation: Get all task objects from database
  Future<List<Map<String, dynamic>>> getAllTaskMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $taskTable ');
    return result;
  }

  // Fetch Operation: Get all task objects from database
  Future<List<Map<String, dynamic>>> getCompleteTaskMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $taskTable WHERE $colType= 1');
    return result;
  }

  // Fetch Operation: Get all task objects from database
  Future<List<Map<String, dynamic>>> getInCompleteTaskMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $taskTable WHERE $colType= 2');
    return result;
  }

  // Insert Operation: Insert a task object to database
  Future<int> inserttask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }

  // Update Operation: Update a task object and save it to database
  Future<int> updatetaskInCompleted(Task task) async {
    var db = await this.database;
    var result = await db
        .update(taskTable, task.toMap(), where: '$colType = ?', whereArgs: [2]);
    return result;
  }

  Future<int> updatetaskCompleted(Task task) async {
    var db = await this.database;
    var result = await db
        .update(taskTable, task.toMap(), where: '$colType = ?', whereArgs: [2]);
    return result;
  }

  // Delete Operation: Delete a task object from database
  Future<int> deletetask(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $taskTable WHERE $colId = $id');
    return result;
  }

  // Get number of task objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $taskTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'task List' [ List<task> ]
  Future<List<Task>> gettaskList(int type) async {
    switch (type) {
      case 1:
        {
          var taskMapList = await getCompleteTaskMapList();
          int count =
              taskMapList.length; // Count the number of map entries in db table

          List<Task> taskList = List<Task>();
          // For loop to create a 'task List' from a 'Map List'
          for (int i = 0; i < count; i++) {
            taskList.add(Task.fromMapObject(taskMapList[i]));
          }

          return taskList; // Get 'Map List' from database
        }
        break;
      case 2:
        {
          var taskMapList = await getInCompleteTaskMapList();
          int count =
              taskMapList.length; // Count the number of map entries in db table

          List<Task> taskList = List<Task>();
          // For loop to create a 'task List' from a 'Map List'
          for (int i = 0; i < count; i++) {
            taskList.add(Task.fromMapObject(taskMapList[i]));
          }

          return taskList; // Get 'Map List' from database
        }
        break;
      default:
        {
          var taskMapList = await getAllTaskMapList();
          int count =
              taskMapList.length; // Count the number of map entries in db table

          List<Task> taskList = List<Task>();
          // For loop to create a 'task List' from a 'Map List'
          for (int i = 0; i < count; i++) {
            taskList.add(Task.fromMapObject(taskMapList[i]));
          }

          return taskList;
        }
        break;
    }
  }
}
