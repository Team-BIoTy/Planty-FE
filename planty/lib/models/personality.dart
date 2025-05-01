class Personality {
  final int id;
  final String label;
  final String emoji;
  final String color;
  final String description;
  final String exampleComment;

  Personality({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    required this.description,
    required this.exampleComment,
  });

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      id: json['id'],
      label: json['label'],
      emoji: json['emoji'],
      color: json['color'] ?? '#FFFFFF',
      description: json['description'],
      exampleComment: json['exampleComment'],
    );
  }
}
