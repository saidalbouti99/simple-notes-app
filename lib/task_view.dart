import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cloud_task.dart';
import 'firestore_storage.dart';
import 'task_list_view.dart';
import 'extensions.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late final FirebaseStorage _notesService;


  @override
  void initState() {
    _notesService = FirebaseStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference todolist = FirebaseFirestore.instance.collection('todolist');

    Future<void> deleteTask() {
      return todolist
          .doc('ABC123')
          .delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudTask>;
                return TaskListView(
                  list: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed('/updateTask', arguments: note);
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