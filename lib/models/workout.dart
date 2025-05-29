class Workout {
  final int? id;
  final String name;
  final String type;

  Workout({this.id, required this.name, required this.type});

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
      };
}
