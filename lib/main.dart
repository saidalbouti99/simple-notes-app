import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'test.dart';

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
    home: GetUserName('iE6CNSbZduHOZAKMCAhI'),
    routes: {
      
    },
  ));
}
