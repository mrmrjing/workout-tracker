import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/database_helper.dart';
import '../views/add_workout_screen.dart';

void main() {
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

class WorkoutListScreen extends StatefulWidget {
  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  List<Workout> workouts = []; // Initialized to an empty list
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshWorkouts();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.close();
    super.dispose();
  }

  Future refreshWorkouts() async {
  setState(() => isLoading = true);
  List<Workout> fetchedWorkouts = await DatabaseHelper.instance.readAllWorkouts();
  workouts = fetchedWorkouts.where((workout) {
    try {
      DateTime.parse(workout.date); // Try parsing the date
      return true; // Include if parsing is successful
    } catch (e) {
      return false; // Exclude if parsing fails
    }
  }).toList();
  setState(() => isLoading = false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts'),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : workouts.isEmpty
              ? Text('No workouts added.')
              : ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return ListTile(
                      title: Text(workout.description),
                      subtitle: Text(DateTime.parse(workout.date).toIso8601String()),
                      onTap: () {
                        // Implement onTap to view or edit workout
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
          ).then((_) => refreshWorkouts());
        },
      ),
    );
  }
}
