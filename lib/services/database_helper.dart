import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/workout.dart';

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
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE workouts (
  id $idType,
  date $dateType,
  description $textType
)
''');
  }

  Future<Workout> create(Workout workout) async {
    final db = await instance.database;
    final id = await db.insert('workouts', workout.toMap());
    return workout.copy(id: id);
  }

  Future<Workout> readWorkout(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'workouts',
      columns: ['id', 'date', 'description'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Workout.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Workout>> readAllWorkouts() async {
    final db = await instance.database;
    const orderBy = 'date ASC';
    final result = await db.query('workouts', orderBy: orderBy);

    return result.map((json) => Workout.fromMap(json)).toList();
  }

  Future<int> update(Workout workout) async {
    final db = await instance.database;
    return db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
