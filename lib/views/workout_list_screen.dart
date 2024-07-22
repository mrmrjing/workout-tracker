import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/database_helper.dart';
import '../views/add_workout_screen.dart';
import '../views/settings_screen.dart'; 
import 'package:intl/intl.dart';

/// This screen displays a list of workouts and offers navigation to add and settings screens.
class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  WorkoutListScreenState createState() => WorkoutListScreenState();
}

class WorkoutListScreenState extends State<WorkoutListScreen> {
  List<Workout> workouts = []; 
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

  /// Fetches workouts from the database and updates the UI state.
  Future<void> refreshWorkouts() async {
    setState(() => isLoading = true);
    workouts = await DatabaseHelper.instance.readAllWorkouts();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        backgroundColor: Colors.blue[800], 
      ),
      drawer: buildDrawer(context),
      body: buildWorkoutList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
        ).then((_) => refreshWorkouts()),
      ),
    );
  }

  /// Builds the main drawer navigation for the app.
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
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
          buildListTile(context, Icons.add, 'Add New Workout', AddWorkoutScreen()),
          buildListTile(context, Icons.settings, 'Settings', SettingsScreen()),
        ],
      ),
    );
  }

  /// Helper to build a ListTile for the drawer menu.
  Widget buildListTile(BuildContext context, IconData icon, String title, Widget destinationScreen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        ).then((_) => refreshWorkouts());
      },
    );
  }

  /// Builds the list of workouts or shows loading/empty messages.
  Widget buildWorkoutList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (workouts.isEmpty) {
      return const Center(child: Text('No workouts added.', style: TextStyle(fontSize: 18, color: Colors.grey)));
    } else {
      return ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) => buildWorkoutCard(context, workouts[index]),
      );
    }
  }

  /// Builds a single workout card with detailed information.
  Widget buildWorkoutCard(BuildContext context, Workout workout) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          "Workout on ${DateFormat('yyyy-MM-dd').format(DateTime.parse(workout.date))}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${workout.exercises.length} exercises${workout.userWeight != null ? ' - ${workout.userWeight} kg' : ''}${workout.location != null ? ' at ${workout.location}' : ''}",
        ),
        children: workout.exercises.map((exercise) => ListTile(
          title: Text(exercise.description),
          subtitle: Text('${exercise.weight} kg - ${exercise.sets} sets x ${exercise.reps} reps'),
        )).toList(),
      ),
    );
  }
}
