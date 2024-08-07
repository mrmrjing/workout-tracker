import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/database_helper.dart';
import '../views/add_workout_screen.dart';
import '../views/settings_screen.dart'; 
import '../views/analytics_screen.dart';
import 'package:intl/intl.dart';

/// This screen displays a list of workouts and offers navigation to various app functions.
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
    refreshWorkouts(); // Refreshing workouts on state initialization
  }

  @override
  void dispose() {
    DatabaseHelper.instance.close(); // Closing database when the screen is disposed
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
        backgroundColor: Colors.blue[800], // Darker shade of blue for the app bar
      ),
      drawer: buildDrawer(context), // Drawer for navigation
      body: buildWorkoutList(), // Main content of the screen
      bottomNavigationBar: buildBottomNavigationBar(context), // Bottom navigation bar
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
          buildListTile(context, Icons.add, 'Add New Workout', const AddWorkoutScreen()),
          buildListTile(context, Icons.settings, 'Settings', const SettingsScreen()),
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
        ).then((_) => refreshWorkouts()); // Refresh workouts on return
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
    String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(workout.date));
    String titlePrefix = workout.focus ?? "Workout";  // Default to "Workout" if no focus is set
    String dynamicTitle = "$titlePrefix: $formattedDate";  // Combines the focus and date

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          dynamicTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${workout.exercises.length} exercises${workout.userWeight != null ? ' - ${workout.userWeight} kg' : ''}${workout.location != null ? ' at ${workout.location}' : ''}",
        ),
        children: workout.exercises.map((exercise) => ListTile(
          title: Text(exercise.description),
          subtitle: Text('${exercise.weight} kg - ${exercise.sets} sets x ${exercise.reps} reps${exercise.additionalInfo != null ? '\nAdditional Info: ${exercise.additionalInfo}' : ''}'),
        )).toList(),
      ),
    );
  }

  /// Constructs the bottom navigation bar for the app.
  Widget buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue[800], // Consistent color with the app bar
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // Placeholder for home or refresh functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Placeholder for search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddWorkoutScreen()),
              ).then((_) => refreshWorkouts()); // Refresh after adding
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Placeholder for notifications functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Placeholder for account or settings functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
