class ExerciseDetail {
  String description;
  double weight;
  int sets;
  int reps;
  String? side; 
  String? additionalInfo; 

  ExerciseDetail({
    required this.description,
    required this.weight,
    required this.sets,
    required this.reps,
    this.side,
    this.additionalInfo,
  });

  // Convert a ExerciseDetail instance into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'side': side,
      'additionalInfo': additionalInfo,
    };
  }

  factory ExerciseDetail.fromMap(Map<String, dynamic> map) {
  // print("Parsing Exercise Detail from Map: $map");
  if (map['description'] == null || map['weight'] == null || map['sets'] == null || map['reps'] == null) {
    throw Exception('Missing mandatory fields for ExerciseDetail');
  }
  return ExerciseDetail(
    description: map['description'],
    weight: double.tryParse(map['weight'].toString()) ?? 0, 
    sets: int.tryParse(map['sets'].toString()) ?? 0,      
    reps: int.tryParse(map['reps'].toString()) ?? 0,      
    side: map['side'],
    additionalInfo: map['additionalInfo'],
  );
}

  // JSON serialization
  factory ExerciseDetail.fromJson(Map<String, dynamic> json) {
    return ExerciseDetail(
      description: json['description'],
      weight: json['weight'].toDouble(),
      sets: json['sets'],
      reps: json['reps'],
      side: json['side'],
      additionalInfo: json['additionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'side': side,
      'additionalInfo': additionalInfo,
    };
  }
}
