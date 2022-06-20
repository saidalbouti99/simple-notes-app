import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'task_view.dart';
import 'create_update_task.dart';
import 'add_new_task.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'To do list',
    theme: ThemeData(
      // Add the 5 lines from here...
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    ),
    // home: const TaskView(),
    initialRoute: '/',
    routes: {
      '/': (context) => const TaskView(),
      '/addTask': (context) => const CreateTask(),
      '/updateTask': (context) => const CreateUpdateTaskView(),
    },
  ));
}
