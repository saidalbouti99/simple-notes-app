import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cloud_task.dart';
import 'firestore_storage.dart';
import 'task_list_view.dart';


extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late final FirebaseStorage _taskService;


  @override
  void initState() {
    _taskService = FirebaseStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: StreamBuilder(
        stream: _taskService.allTasks(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allTasks = snapshot.data as Iterable<CloudTask>;
                return TaskListView(
                  list: allTasks,
                  onDeleteTask: (task) async {
                    await _taskService.deleteTask(documentId: task.documentId);
                  },
                  onTap: (task) {
                    Navigator.of(context).pushNamed('/updateTask', arguments: task);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
          onPressed: () {
            Navigator.pushNamed(context, '/addTask');
          },
          child: const Icon(Icons.add),
      ),
    );
  }
}