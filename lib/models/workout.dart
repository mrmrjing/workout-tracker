import 'dart:convert';
import 'exercise_detail.dart';

class Workout {
  int? id;
  String date;
  List<ExerciseDetail> exercises;
  double? userWeight;  
  String? location; 
  String? focus;  

  Workout({
    this.id,
    required this.date,
    required this.exercises,
    this.userWeight,
    this.location,
    this.focus,
  });

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

  factory Workout.fromMap(Map<String, dynamic> map) {
  List<ExerciseDetail> parsedExercises = List<ExerciseDetail>.from(
    jsonDecode(map['exercises']).map((x) => ExerciseDetail.fromMap(x as Map<String, dynamic>))
  );

  double? parsedWeight = map['userWeight'] != null ? double.parse(map['userWeight'].toString()) : null;
  String? parsedLocation = map['location'];
  String? parsedFocus = map['focus'];

  print("Parsed Focus: $parsedFocus");

  return Workout(
    id: map['id'],
    date: map['date'],
    exercises: parsedExercises,
    userWeight: parsedWeight,
    location: parsedLocation,
    focus: parsedFocus,
  );
}

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
