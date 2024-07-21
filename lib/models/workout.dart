class Workout {
  final int? id; // Make id nullable to handle cases where it isn't set yet (e.g., before being inserted into the database)
  final String date;
  final String description;

  Workout({this.id, required this.date, required this.description});

  // Adding a copy method
  Workout copy({int? id, String? date, String? description}) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // Only add id to map if it is not null
      'date': date,
      'description': description,
    };
  }

  static Workout fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      date: map['date'],
      description: map['description'],
    );
  }
}
