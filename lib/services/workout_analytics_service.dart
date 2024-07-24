import 'package:intl/intl.dart';
import '../models/workout.dart';
import 'database_helper.dart';

class WorkoutAnalyticsService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Fetches all workouts and computes analytics
  Future<Map<String, dynamic>> getWorkoutAnalytics() async {
    List<Workout> workouts = await _dbHelper.readAllWorkouts();
    return {
      'totalWorkouts': workouts.length,
      // 'averageDuration': _calculateAverageDuration(workouts),
      'workoutsPerWeek': _calculateFrequency(workouts),
    };
  }

  /// Calculates the average duration of workouts
  // double _calculateAverageDuration(List<Workout> workouts) {
  //   if (workouts.isEmpty) return 0.0;
  //   // The fold operation should accumulate into a double to avoid integer division
  //   final totalDuration = workouts.fold<double>(0.0, (sum, workout) => sum + workout.duration.toDouble());
  //   return totalDuration / workouts.length;
  // }


  /// Calculates frequency of workouts per week
  double _calculateFrequency(List<Workout> workouts) {
    if (workouts.isEmpty) return 0;
    int weeksCovered = _getNumberOfWeeksCovered(workouts);
    return weeksCovered > 0 ? workouts.length / weeksCovered : 0;
  }

  /// Determines the number of weeks covered by the logged workouts
  int _getNumberOfWeeksCovered(List<Workout> workouts) {
    if (workouts.isEmpty) return 0;
    DateTime earliestDate = DateFormat('yyyy-MM-dd').parse(workouts.first.date);
    DateTime latestDate = DateFormat('yyyy-MM-dd').parse(workouts.last.date);
    return latestDate.difference(earliestDate).inDays ~/ 7;
  }
}
