import 'dart:convert';
import 'exercise_detail.dart';
import 'package:flutter/material.dart'; 

class Workout {
  int? id;
  String date;
  List<ExerciseDetail> exercises;
  double? userWeight;  // Body weight on the day of the workout
  String? location; // Optional field for tracking workout location

  Workout({
    this.id,
    required this.date,
    required this.exercises,
    this.userWeight,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'exercises': jsonEncode(exercises.map((e) => e.toJson()).toList()),
      'userWeight': userWeight,
      'location': location,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
  print("Parsing Workout from Map: $map");

  List<ExerciseDetail> parsedExercises = List<ExerciseDetail>.from(
    jsonDecode(map['exercises']).map((x) => ExerciseDetail.fromMap(x as Map<String, dynamic>))
  );
  print("Parsed Exercises: ${parsedExercises.map((e) => e.description).join(', ')}");

  double? parsedWeight = map['userWeight'] != null ? double.parse(map['userWeight'].toString()) : null;
  String? parsedLocation = map['location'];

  print("Parsed Weight: $parsedWeight");
  print("Parsed Location: $parsedLocation");

  return Workout(
    id: map['id'],
    date: map['date'],
    exercises: parsedExercises,
    userWeight: parsedWeight,
    location: parsedLocation,
  );
}

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      date: json['date'],
      exercises: List<ExerciseDetail>.from(
        json['exercises'].map((x) => ExerciseDetail.fromJson(x))
      ),
      userWeight: json['userWeight'] != null ? json['userWeight'].toDouble() : null,
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'userWeight': userWeight,
      'location': location,
    };
  }
}
