import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../services/workout_analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<Map<String, dynamic>> analyticsData;

  @override
  void initState() {
    super.initState();
    analyticsData = WorkoutAnalyticsService().getWorkoutAnalytics();
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
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                _buildStatisticCard('Total Workouts', snapshot.data!['totalWorkouts'].toString(), Icons.fitness_center),
                _buildStatisticCard('Average Workout Duration (min)', snapshot.data!['averageDuration'].toStringAsFixed(2), Icons.timer),
                _buildStatisticCard('Workouts Per Week', snapshot.data!['workoutsPerWeek'].toStringAsFixed(2), Icons.date_range),
                _buildBarChart(snapshot.data!),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

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

  Widget _buildBarChart(Map<String, dynamic> data) {
    List<charts.Series<dynamic, String>> series = [
      charts.Series<dynamic, String>(
        id: 'Workouts',
        domainFn: (var workout, _) => workout['label'] as String,
        measureFn: (var workout, _) => workout['value'] as int,
        data: [
          {'label': 'Total Workouts', 'value': data['totalWorkouts']},
          {'label': 'Avg Duration', 'value': (data['averageDuration'] * 10).toInt()}, // Multiplied to scale with total workouts
          {'label': 'Workouts/Week', 'value': (data['workoutsPerWeek'] * 10).toInt()}, // Multiplied for visual scaling
        ],
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (var row, _) => '${row['value']}',
      )
    ];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: charts.BarChart(
        series,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend()],
      ),
    );
  }
}
