// Create a UI where users can input the details of their workout 
// handle the form submission
// call the database helper to insert the data into the database 

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Make sure to have this import for date formatting
import '../models/workout.dart';
import '../services/database_helper.dart';

class AddWorkoutScreen extends StatefulWidget {
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _date; // Making this nullable to handle initial state
  late String _description;

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_date != null) { // Ensure date is not null
        Workout newWorkout = Workout(date: _date!, description: _description);
        await DatabaseHelper.instance.create(newWorkout);
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
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true, // Prevent keyboard from opening
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date = DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
                    });
                  }
                },
                controller: TextEditingController(text: _date), // Display selected date
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
