import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

const snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
);
class _CreateTaskState extends State<CreateTask> {

  final _task = TextEditingController();
  final _description=TextEditingController();

  String text='';
  @override
  Widget build(BuildContext context) {
    CollectionReference todolist = FirebaseFirestore.instance.collection('todolist');

    void showSnackbar(){
      final snackBar = SnackBar(
        content: const Text('Yay! A SnackBar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    @override
    void dispose() {
      _task.dispose();
      _description.dispose();
      super.dispose();
    }
    Future<void> addTask() {
      return todolist
          .add({
        'list': _task.text,
      })
          .then(
              (_) => Navigator.of(context).popAndPushNamed('/'),
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
              child: TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(
                    Icons.info,
                  ),
                  contentPadding: EdgeInsets.all(8.0),
                  border: OutlineInputBorder(),
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
