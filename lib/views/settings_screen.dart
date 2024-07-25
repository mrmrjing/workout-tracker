import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../models/exercise_detail.dart';
import '../services/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _date;
  final List<ExerciseDetail> _exercises = [];
  final _controllerDate = TextEditingController();

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  void _addExercise() {
    // Function to add a new exercise to the list, using form data
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save current state of the form
      Navigator.of(context).pop();    // Optionally close the settings screen
    }
  }

  void _saveWorkout() async {
    if (_date != null && _exercises.isNotEmpty) {
      Workout newWorkout = Workout(date: _date!, exercises: _exercises);
      await DatabaseHelper.instance.createWorkout(newWorkout);
      Navigator.of(context).pop(); // Return to previous screen after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Workout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date'),
                  controller: _controllerDate,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _controllerDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      _date = _controllerDate.text;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date.';
                    }
                    return null;
                  },
                ),
                // Additional form fields to add exercises will be similar to the AddWorkoutScreen
                ElevatedButton(
                  onPressed: _saveWorkout,
                  child: const Text('Save Workout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
