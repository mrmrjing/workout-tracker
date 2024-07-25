import 'package:flutter/material.dart';
import '../services/workout_analytics_service.dart';

/// Represents the analytics screen as a stateful widget.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

/// State class for the AnalyticsScreen which manages the lifecycle and state.
class AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<Map<String, dynamic>> analyticsData;
  bool sortAscending = true;
  int? sortColumnIndex;

  /// Initialize state and fetch analytics data asynchronously on widget creation.
  @override
  void initState() {
    super.initState();
    analyticsData = WorkoutAnalyticsService().getWorkoutAnalytics();
  }

  /// Sorts data in ascending or descending order based on user input in the DataTable.
  void _sort<T>(Comparable<T> Function(MapEntry<String, double> d) getField, int columnIndex, bool ascending, Map<String, double>? data) {
    final entries = data!.entries.toList();
    entries.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
      data
        ..clear()
        ..addEntries(entries);
    });
  }

  /// Builds the main scaffold of the analytics screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Analytics'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: analyticsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                _buildStatisticCard('Total Workouts', snapshot.data?['totalWorkouts']?.toString() ?? 'N/A', Icons.fitness_center),
                _buildStatisticCard('Average Workout Duration (min)', snapshot.data?['averageDuration']?.toStringAsFixed(2) ?? 'N/A', Icons.timer),
                _buildStatisticCard('Workouts Per Week', snapshot.data?['workoutsPerWeek']?.toStringAsFixed(2) ?? 'N/A', Icons.date_range),
                _buildCollapsibleSection(snapshot.data?['averageWeightPerExercise'], "Average Weight per Exercise (kg)", Icons.line_weight),
                _buildCollapsibleSection(snapshot.data?['averageRepsPerExercise'], "Average Reps per Exercise", Icons.repeat),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Utility function that capitalises each word in a string
  String capitalize(String text) {
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  Widget _buildCollapsibleSection(Map<String, double>? data, String title, IconData icon) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: Icon(icon, size: 50),  
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                _createDataTable(data, title.contains("Weight")),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Creates a data table widget for displaying sorted exercise data.
  Widget _createDataTable(Map<String, double>? data, bool isWeight) {
    final String type = isWeight ? "Weight (kg)" : "Reps";
    final String header = isWeight ? "Average Weight per Exercise (kg)" : "Average Reps per Exercise";
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
        columns: [
          DataColumn(
            label: const Text('Exercise'),
            onSort: (columnIndex, ascending) {
              _sort<String>((d) => d.key, columnIndex, ascending, data);
            },
          ),
          DataColumn(
            label: Text(header),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _sort<num>((d) => d.value, columnIndex, ascending, data);
            },
          ),
        ],
        rows: data!.entries.map(
          (entry) => DataRow(
            cells: [
              DataCell(Text(capitalize(entry.key), overflow: TextOverflow.ellipsis)),
              DataCell(Text('${entry.value.toStringAsFixed(1)} ${isWeight ? "kg" : ""}')),
            ],
          ),
        ).toList(),
    ));
  }

  /// Builds a statistics card for displaying key workout metrics.
  Widget _buildStatisticCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon, size: 50),
        title: Text(title),
        subtitle: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}