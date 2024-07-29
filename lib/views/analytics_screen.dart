import 'package:flutter/material.dart';
import '../services/workout_analytics_service.dart';

/// A screen that provides analytics on user workouts, represented as a stateful widget.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

/// Manages the state of the AnalyticsScreen, fetching and displaying analytics data.
class AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<Map<String, dynamic>> analyticsData; // Future for handling asynchronous fetch of analytics data.
  bool sortAscending = true; // Controls the sorting direction of the data table.
  int? sortColumnIndex; // Tracks the column index used for sorting data in the table.

  @override
  void initState() {
    super.initState();
    // Fetch analytics data asynchronously on widget initialization.
    analyticsData = WorkoutAnalyticsService().getWorkoutAnalytics();
  }

  /// Sorts the provided data in ascending or descending order based on user interaction.
  void _sort<T>(Comparable<T> Function(MapEntry<String, double> d) getField, int columnIndex, bool ascending, Map<String, double>? data) {
    final entries = data!.entries.toList(); // Convert map entries to a list for sorting.
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
        ..addEntries(entries); // Update the data with sorted entries.
    });
  }

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
            return Center(child: Text("Error: ${snapshot.error}")); // Display errors if any.
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
            return const Center(child: Text('No data available')); // Display when no data is available.
          }
        },
      ),
    );
  }

  /// Builds a collapsible section for displaying detailed analytics about exercises.
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
    final String type = isWeight ? "Weight (kg)" : "Reps"; // Determines the type based on the context.
    final String header = isWeight ? "Average Weight per Exercise (kg)" : "Average Reps per Exercise";
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
        columns: [
          DataColumn(
            label: const Text('Exercise'),
            onSort: (columnIndex, ascending) => _sort<String>((d) => d.key, columnIndex, ascending, data),
          ),
          DataColumn(
            label: Text(header),
            numeric: true,
            onSort: (columnIndex, ascending) => _sort<num>((d) => d.value, columnIndex, ascending, data),
          ),
        ],
        rows: data!.entries.map(
          (entry) => DataRow(
            cells: [
              DataCell(Text(entry.key, overflow: TextOverflow.ellipsis)), // Exercise name.
              DataCell(Text('${entry.value.toStringAsFixed(1)} ${isWeight ? "kg" : ""}')), // Display formatted data.
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
        leading: Icon(icon, size: 50), // Icon for the metric.
        title: Text(title), // Metric title.
        subtitle: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Value of the metric.
      ),
    );
  }
}
