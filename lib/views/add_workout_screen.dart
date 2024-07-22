import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For date formatting
import '../models/workout.dart';
import '../models/exercise_detail.dart';  // Make sure to import ExerciseDetail
import '../services/database_helper.dart';

class AddWorkoutScreen extends StatefulWidget {
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _date; // Date of the workout
  List<ExerciseDetail> _exercises = []; // List of exercises

  void _addExerciseDetail() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _exercises.add(ExerciseDetail(
        description: _controllerDescription.text,
        weight: double.parse(_controllerWeight.text),
        sets: int.parse(_controllerSets.text),
        reps: int.parse(_controllerReps.text),
      ));
      _controllerDescription.clear();
      _controllerWeight.clear();
      _controllerSets.clear();
      _controllerReps.clear();
    }
  }

  // Controllers for form fields
  final _controllerDescription = TextEditingController();
  final _controllerWeight = TextEditingController();
  final _controllerSets = TextEditingController();
  final _controllerReps = TextEditingController();

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_date != null && _exercises.isNotEmpty) { // Ensure date and exercises are valid
        Workout newWorkout = Workout(date: _date!, exercises: _exercises);
        await DatabaseHelper.instance.createWorkout(newWorkout);
        Navigator.of(context).pop(); // Optionally pop the current screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Workout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                controller: TextEditingController(text: _date),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date.';
                  }
                  return null;
                },
              ),
              for (var i = 0; i < _exercises.length; i++)
                ListTile(
                  title: Text("${_exercises[i].description} - ${_exercises[i].weight}kg x ${_exercises[i].sets} sets of ${_exercises[i].reps} reps"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _exercises.removeAt(i);
                      });
                    },
                  ),
                ),
              TextFormField(
                controller: _controllerDescription,
                decoration: InputDecoration(labelText: 'Exercise Description'),
                validator: (value) => value!.isEmpty ? 'Enter exercise description' : null,
              ),
              TextFormField(
                controller: _controllerWeight,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter weight' : null,
              ),
              TextFormField(
                controller: _controllerSets,
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter number of sets' : null,
              ),
              TextFormField(
                controller: _controllerReps,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter number of reps' : null,
              ),
              ElevatedButton(
                onPressed: _addExerciseDetail,
                child: Text('Add Exercise'),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Save Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
