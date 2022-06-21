import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}


class _CreateTaskState extends State<CreateTask> {

  final _task = TextEditingController();

  String text='';
  @override
  Widget build(BuildContext context) {
    CollectionReference todolist = FirebaseFirestore.instance.collection('todolist');

    @override
    void dispose() {
      _task.dispose();
      super.dispose();
    }
    Future<void> addTask() {
      return todolist
          .add({
        'list': _task.text,
      })
          .then(
              // (_) => Navigator.of(context).popAndPushNamed('/'),
            (_) => Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false),
      )
          .catchError((error) => print("Failed to add task: $error"));
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Add Task',
            // style: context.titleLarge,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _task,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.task,
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Task',
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: addTask,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text(
                    'Add Task',
                    style: TextStyle(
                      color: Colors.white,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
