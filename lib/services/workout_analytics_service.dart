import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../models/exercise_detail.dart';
import 'database_helper.dart';

class WorkoutAnalyticsService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Fetches all workouts and computes analytics
  Future<Map<String, dynamic>> getWorkoutAnalytics() async {
  List<Workout> workouts = await _dbHelper.readAllWorkouts();

  Map<DateTime, double> totalWeightPerSession = _calculateTotalWeightPerSession(workouts);
  Map<DateTime, double> totalRepsPerSession = _calculateTotalRepsPerSession(workouts);

  return {
    'totalWorkouts': workouts.length,
    'workoutsPerWeek': _calculateFrequency(workouts),
    'averageWeightPerExercise': await _calculateAverageWeightPerExercise(workouts),
    'totalWeightPerSession': totalWeightPerSession,
    'averageRepsPerExercise': await _calculateAverageRepsPerExercise(workouts),
    'totalRepsPerSession': totalRepsPerSession  
  };
}

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

  /// Calculates the average weight lifted per exercise across all workouts
  Future<Map<String, double>> _calculateAverageWeightPerExercise(List<Workout> workouts) async {
    Map<String, List<double>> weights = {};
    for (Workout workout in workouts) {
      for (ExerciseDetail exercise in workout.exercises) {
        if (!weights.containsKey(exercise.description)) {
          weights[exercise.description] = [];
        }
        weights[exercise.description]!.add(exercise.weight);
      }
    }

    Map<String, double> averages = {};
    weights.forEach((description, weightList) {
      double total = weightList.reduce((sum, element) => sum + element);
      averages[description] = total / weightList.length;
    });

    return averages;
  }

  /// Calculates the total reps performed per session across all workouts
  Map<DateTime, double> _calculateTotalRepsPerSession(List<Workout> workouts) {
    Map<DateTime, double> totalReps = {};
    for (Workout workout in workouts) {
      double sessionTotal = workout.exercises.fold(0.0, (sum, next) => sum + (next.reps * next.sets));
      totalReps[DateTime.parse(workout.date)] = sessionTotal;
    }
    return totalReps;
  }



  /// Calculates the total weight lifted per session across all workouts
  Map<DateTime, double> _calculateTotalWeightPerSession(List<Workout> workouts) {
    Map<DateTime, double> totalWeights = {};
    for (Workout workout in workouts) {
      double sessionTotal = workout.exercises.fold(0.0, (sum, next) => sum + (next.weight * next.sets * next.reps));
      totalWeights[DateTime.parse(workout.date)] = sessionTotal;
    }
    return totalWeights;
  }

  /// Calculates the average number of reps per exercise across all workouts
  Future<Map<String, double>> _calculateAverageRepsPerExercise(List<Workout> workouts) async {
    Map<String, List<int>> reps = {};
    for (Workout workout in workouts) {
      for (ExerciseDetail exercise in workout.exercises) {
        if (!reps.containsKey(exercise.description)) {
          reps[exercise.description] = [];
        }
        reps[exercise.description]!.add(exercise.reps);
      }
    }

    Map<String, double> averages = {};
    reps.forEach((description, repList) {
      int total = repList.reduce((sum, element) => sum + element);
      averages[description] = total / repList.length;
    });

    return averages;
  }


}
