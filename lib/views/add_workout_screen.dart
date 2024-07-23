import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../models/exercise_detail.dart';
import '../services/database_helper.dart';

/// This screen allows the user to add a new workout with multiple exercises.
class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  AddWorkoutScreenState createState() => AddWorkoutScreenState();
}

/// State for AddWorkoutScreen that handles adding exercises and submitting a complete workout.
class AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<ExerciseDetail> _exercises = [];
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerWeight = TextEditingController();
  final TextEditingController _controllerSets = TextEditingController();
  final TextEditingController _controllerReps = TextEditingController();
  final TextEditingController _controllerFocus = TextEditingController();
  String? _date;
  // ignore: unused_field
  bool _isLoading = false; // Indicates whether the submission is in progress.

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    _controllerDescription.dispose();
    _controllerWeight.dispose();
    _controllerSets.dispose();
    _controllerReps.dispose();
    _controllerFocus.dispose();
    super.dispose();
  }

  /// Adds an exercise to the workout from the form data if it's valid.
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Exercise added successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please correct the errors in the form before adding the exercise.")),
      );
    }
  }

  /// Submits all data to the database after validating current inputs and checking if there's at least one exercise.
  void _submitData() async {
    if (_exercises.isEmpty && !_isCurrentInputValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No exercises to save. Please add at least one exercise before saving the workout.")),
      );
      return;
    }

    if (_isCurrentInputValid()) {
      if (!_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please correct the errors in the form before saving.")),
        );
        return;
      }
      _addCurrentInputAsExercise();
    }

    setState(() => _isLoading = true);
    try {
      Workout newWorkout = Workout(date: _date!, exercises: _exercises, focus: _controllerFocus.text);
      await DatabaseHelper.instance.createWorkout(newWorkout);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workout saved successfully!")),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save workout: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Adds the current input as an exercise if all fields are filled correctly.
  void _addCurrentInputAsExercise() {
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

  /// Checks if the current form inputs are valid for adding as an exercise.
  bool _isCurrentInputValid() {
    return _controllerDescription.text.isNotEmpty &&
           _controllerWeight.text.isNotEmpty &&
           _controllerSets.text.isNotEmpty &&
           _controllerReps.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Workout')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildDateField(),
              _buildTextField(_controllerFocus, 'Workout Focus', 'Enter workout focus'),
              ..._exercises.map(_buildExerciseTile),
              _buildTextField(_controllerDescription, 'Exercise Description', 'Enter exercise description'),
              _buildTextField(_controllerWeight, 'Weight (kg)', 'Enter weight', isNumeric: true),
              _buildTextField(_controllerSets, 'Sets', 'Enter number of sets', isNumeric: true),
              _buildTextField(_controllerReps, 'Reps', 'Enter number of reps', isNumeric: true),
              _buildButton('Add Exercise', _addExerciseDetail),
              _buildButton('Save Workout', _submitData),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), 
        ),
        child: Text(title),
      ),
    );
  }


  /// Builds a text field for entering dates with a date picker.
  Widget _buildDateField() => TextFormField(
    decoration: const InputDecoration(labelText: 'Date'),
    readOnly: true,
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) setState(() => _date = DateFormat('yyyy-MM-dd').format(pickedDate));
    },
    controller: TextEditingController(text: _date),
    validator: (value) => value == null || value.isEmpty ? 'Please enter a date.' : null,
  );

  /// Builds a generic text field for form inputs with enhanced spacing.
Widget _buildTextField(TextEditingController controller, String label, String errorText, {bool isNumeric = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0), // Adds vertical space between fields
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(), // Optional: adds a border to make the input field more prominent
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) return errorText;
        if (isNumeric && double.tryParse(value) == null) return 'Please enter a valid number.';
        return null;
      },
    ),
  );
}

  /// Builds a list tile for an exercise detail with a delete button.
  Widget _buildExerciseTile(ExerciseDetail detail) => ListTile(
    title: Text("${detail.description} - ${detail.weight}kg x ${detail.sets} sets of ${detail.reps} reps"),
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => setState(() => _exercises.remove(detail)),
    ),
  );
}
