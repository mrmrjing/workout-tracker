import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/database_helper.dart';
import '../views/add_workout_screen.dart';
import '../views/settings_screen.dart'; // Ensure these are the correct imports for your screens
import 'package:intl/intl.dart';

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

  Future<void> refreshWorkouts() async {
    setState(() => isLoading = true);
    workouts = await DatabaseHelper.instance.readAllWorkouts();
    print('Workouts after refresh: ${workouts.length}');
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts'),
        backgroundColor: Colors.blue[800], // Enhanced AppBar color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add New Workout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
                ).then((_) => refreshWorkouts());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                ).then((_) => refreshWorkouts());
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : workouts.isEmpty
              ? Center(child: Text('No workouts added.', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    List<Widget> details = [
                      ListTile(
                        title: Text("Workout on ${DateTime.parse(workout.date).toIso8601String()}"),
                        subtitle: Text("${workout.exercises.length} exercises"),
                      )
                    ];

                    if (workout.userWeight != null) {
                      details.add(ListTile(
                        title: Text("Weight"),
                        subtitle: Text("${workout.userWeight} kg"),
                      ));
                    }

                    if (workout.location != null) {
                      details.add(ListTile(
                        title: Text("Location"),
                        subtitle: Text(workout.location!),
                      ));
                    }
                    

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Text("Workout on ${DateFormat('yyyy-MM-dd').format(DateTime.parse(workout.date))}", style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${workout.exercises.length} exercises${workout.userWeight != null ? ' - ${workout.userWeight} kg' : ''}${workout.location != null ? ' at ${workout.location}' : ''}"),
                        children: workout.exercises.map((exercise) => ListTile(
                          title: Text(exercise.description),
                          subtitle: Text('${exercise.weight} kg - ${exercise.sets} sets x ${exercise.reps} reps'),
                        )).toList(),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
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
