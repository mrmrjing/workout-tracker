import 'dart:convert';
import 'exercise_detail.dart';

/// Represents a workout consisting of multiple exercises, optionally including metadata like weight and focus.
class Workout {
  int? id;
  String date;
  List<ExerciseDetail> exercises;
  double? userWeight;  
  String? location; 
  String? focus;  

  /// Constructs a new `Workout` instance.
  Workout({
    this.id,
    required this.date,
    required this.exercises,
    this.userWeight,
    this.location,
    this.focus,
  });

  /// Converts a `Workout` instance to a Map for database storage, encoding the list of exercises as JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'exercises': jsonEncode(exercises.map((e) => e.toJson()).toList()),
      'userWeight': userWeight,
      'location': location,
      'focus': focus,
    };
  }

  /// Creates a `Workout` instance from a Map, typically from database fields, decoding JSON for the exercises.
  factory Workout.fromMap(Map<String, dynamic> map) {
    List<ExerciseDetail> parsedExercises = List<ExerciseDetail>.from(
      jsonDecode(map['exercises']).map((x) => ExerciseDetail.fromMap(x as Map<String, dynamic>))
    );

    double? parsedWeight = map['userWeight'] != null ? double.parse(map['userWeight'].toString()) : null;
    String? parsedLocation = map['location'];
    String? parsedFocus = map['focus'];

    return Workout(
      id: map['id'],
      date: map['date'],
      exercises: parsedExercises,
      userWeight: parsedWeight,
      location: parsedLocation,
      focus: parsedFocus,
    );
  }

  /// Creates a `Workout` instance from a JSON object, for scenarios like fetching from an API or config file.
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      date: json['date'],
      exercises: List<ExerciseDetail>.from(
        json['exercises'].map((x) => ExerciseDetail.fromJson(x))
      ),
      userWeight: json['userWeight']?.toDouble(),
      location: json['location'],
      focus: json['focus'], 
    );
  }

  /// Converts a `Workout` instance to a JSON object for easy serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'userWeight': userWeight,
      'location': location,
      'focus': focus,
    };
  }
}
