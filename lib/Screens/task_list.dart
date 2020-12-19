import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:todo_list/Models/Task.dart';
import 'package:todo_list/Utils/database_helper.dart';

class TaskList extends StatefulWidget {
  int type = 0;
  TaskList(int type) {
    this.type = type;
  }
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Task> taskList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }

    return Center(
      child: gettaskListView(),
    );
  }

  ListView gettaskListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.taskList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.taskList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, taskList[position]);
                  },
                ),
                Checkbox(
                  value: taskList[position].type == 2,
                  onChanged: (value) {
                    if (taskList[position].type == 1) {
                      _changeTypeCompleted(context, taskList[position]);
                    } else if (taskList[position].type == 2) {
                      _changeTypeInCompleted(context, taskList[position]);
                    }
                  },
                )
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              // navigateToDetail(this.taskList[position], 'Edit task');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Task task) async {
    int result = await databaseHelper.deletetask(task.id);
    if (result != 0) {
      _showSnackBar(context, 'task Deleted Successfully');
      updateListView();
    }
  }

  void _changeTypeCompleted(BuildContext context, Task task) async {
    int result = await databaseHelper.updatetaskCompleted(task);
    if (result != 0) {
      _showSnackBar(context, 'task Completed Successfully');
      updateListView();
    }
  }

  void _changeTypeInCompleted(BuildContext context, Task task) async {
    int result = await databaseHelper.updatetaskInCompleted(task);
    if (result != 0) {
      _showSnackBar(context, 'task InCompleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> todoListFuture = databaseHelper.gettaskList(0);
      todoListFuture.then((todoList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }
}
