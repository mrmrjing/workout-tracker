import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'views/workout_list_screen.dart'; 
import 'services/database_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure proper initialization
  print('Database path: ${await getDatabasesPath()}');
  await DatabaseHelper.instance.importWorkoutsFromJson();  // Ensure database is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutListScreen(),
    );
  }
}
