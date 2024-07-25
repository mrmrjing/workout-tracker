import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../models/goals.dart';
import '../models/workout.dart';
import '../models/exercise_detail.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workouts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL';  
    const optionalTextType = 'TEXT';  // Nullable

    await db.execute('''
    CREATE TABLE workouts (
      id $idType,
      date $textType,
      exercises $textType,
      location $optionalTextType,
      userWeight $realType,
      focus $optionalTextType
    )
    ''');

    // Table for goals
    await db.execute('''
    CREATE TABLE goals (
      id $idType,
      title $textType,
      description $textType
    )
    ''');
  }

  Future<Workout> createWorkout(Workout workout) async {
  final db = await database;
  final exercisesJson = jsonEncode(workout.exercises.map((e) => e.toJson()).toList());
  print('Inserting workout: $exercisesJson');

  try {
    final id = await db.insert('workouts', workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print('Inserted workout with id: $id');
    return Workout(
      id: id,
      date: workout.date,
      exercises: workout.exercises,
      userWeight: workout.userWeight,
      location: workout.location,
      focus: workout.focus
    );
  } catch (e) {
    print('Error when inserting a new workout: $e');
    throw Exception('Failed to create workout');
  }
}



  Future<Workout> readWorkout(int id) async {
    final db = await database;
    final maps = await db.query(
      'workouts',
      columns: ['id', 'date', 'exercises', 'userWeight', 'location', 'focus'], 
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Workout(
        id: maps.first['id'] as int,
        date: maps.first['date'] as String,
        exercises: List<ExerciseDetail>.from(
          jsonDecode(maps.first['exercises'].toString()).map((x) => ExerciseDetail.fromMap(x))
        ),
        userWeight: maps.first['userWeight'] as double,
        location: maps.first['location'] as String,
        focus: maps.first['focus'] as String
      );
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Workout>> readAllWorkouts() async {
  final db = await database;
  final result = await db.query('workouts', orderBy: 'date ASC');
  

  return result.map((map) {
    final exercisesData = map['exercises'] as String?;
    List<ExerciseDetail> exercises = [];
    if (exercisesData != null && exercisesData.isNotEmpty) {
      exercises = List<ExerciseDetail>.from(
        jsonDecode(exercisesData).map((x) => ExerciseDetail.fromMap(x as Map<String, dynamic>))
      );
    }
    return Workout(
      id: map['id'] as int?,
      date: map['date'] as String,
      exercises: exercises,
      userWeight: map['userWeight'] as double?,
      location: map['location'] as String?,
      focus: map['focus'] as String?
    );
  }).toList();
}


  Future<int> updateWorkout(Workout workout) async {
    final db = await database;
    return db.update(
      'workouts',
      {
        'date': workout.date,
        'exercises': jsonEncode(workout.exercises.map((e) => e.toMap()).toList()),
        'userWeight': workout.userWeight,
        'location': workout.location,
        'focus': workout.focus
      },
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await database;
    return db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for goals (remain unchanged)
  Future<Goal> createGoal(Goal goal) async {
    final db = await instance.database;
    final id = await db.insert('goals', goal.toMap());
    return goal.copy(id: id);
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await instance.database;
    return db.update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  Future<int> deleteGoal(int id) async {
    final db = await instance.database;
    return db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Goal>> readAllGoals() async {
    final db = await instance.database;
    final result = await db.query('goals', orderBy: 'id ASC');
    return result.map((map) => Goal.fromMap(map)).toList();
  }

  Future<void> importWorkoutsFromJson() async {
  final String response = await rootBundle.loadString('lib/assets/workout.json');
  final data = await json.decode(response);
  final db = await database;
  var batch = db.batch();
  for (var workoutData in data) {
    var workout = Workout.fromMap({
      'id': workoutData['id'],  
      'date': workoutData['date'],
      'exercises': jsonEncode(workoutData['exercises']),  
      'userWeight': workoutData['userWeight'],
      'location': workoutData['location'],
      'focus': workoutData['focus']
    });
    batch.insert('workouts', workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  await batch.commit(noResult: true);
  print("Workouts imported.");
}


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
