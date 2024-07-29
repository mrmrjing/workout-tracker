/// Represents the details of an exercise within a workout, encapsulating all relevant metrics.
class ExerciseDetail {
  String _description;
  double weight;
  int sets;
  int reps;
  String? side;  
  String? additionalInfo;  

  /// Constructs a new `ExerciseDetail` instance with normalization for the description.
  ExerciseDetail({
    required String description,
    required this.weight,
    required this.sets,
    required this.reps,
    this.side,
    this.additionalInfo,
  }) : _description = normalizeDescription(description);

  /// Sets the exercise description after normalizing it.
  set description(String newValue) {
    _description = normalizeDescription(newValue);
  }

  /// Returns the exercise description.
  String get description => _description;

  /// Normalizes the exercise description by trimming whitespace, replacing multiple spaces with a single space, and converting to lowercase.
  static String normalizeDescription(String description) {
    return description.trim().replaceAll(RegExp(' +'), ' ').toLowerCase();
  }

  /// Converts an `ExerciseDetail` instance into a Map. Useful for database storage and serialization.
  Map<String, dynamic> toMap() {
    return {
      'description': _description,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'side': side,
      'additionalInfo': additionalInfo,
    };
  }

  /// Constructs an `ExerciseDetail` from a Map.
  factory ExerciseDetail.fromMap(Map<String, dynamic> map) {
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

  /// Creates an `ExerciseDetail` instance from a JSON object. 
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

  /// Converts an `ExerciseDetail` instance to a JSON object. Useful for serialization or sending data over network.
  Map<String, dynamic> toJson() {
    return {
      'description': _description,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'side': side,
      'additionalInfo': additionalInfo,
    };
  }
}
