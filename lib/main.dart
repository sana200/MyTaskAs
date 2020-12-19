import 'package:flutter/material.dart';
import 'package:todo_list/Screens/task_list.dart';

import 'Models/Task.dart';
import 'Screens/task_detail.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'My Tasks',
      theme: ThemeData.light(),
      home: TabsScreen(),
    );
  }
}

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Tasks'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Tasks'),
              Tab(text: 'Complete Tasks'),
              Tab(text: 'InComplete Task')
            ],
          ),
        ),
        body: TabBarView(
          children: [TaskList(0), TaskList(1), TaskList(2)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB clicked');
            navigateToDetail(Task('', 0), 'Add task');
          },
          tooltip: 'Add task',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void navigateToDetail(Task todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaskDetail(todo, title);
    }));
  }
}
