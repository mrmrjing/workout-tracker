import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'views/workout_list_screen.dart'; 

/// The main entry point for the application.
void main() async {
  // Ensure widgets are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Debug print to verify the database path.
  print('Database path: ${await getDatabasesPath()}');

  // Uncomment the line below to import workouts from a JSON file on app startup.
  // await DatabaseHelper.instance.importWorkoutsFromJson();
  
  // Run the app, starting with the MyApp widget.
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Constructs an instance of MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        // Defines the color theme of the application.
        primarySwatch: Colors.blue,
      ),
      // Sets the main screen of the app to be the workout list screen.
      home: const WorkoutListScreen(),
    );
  }
}
