class Personality {
  final int id;
  final String label;
  final String emoji;
  final String description;
  final String exampleComment;

  Personality({
    required this.id,
    required this.label,
    required this.emoji,
    required this.description,
    required this.exampleComment,
  });

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      id: json['id'],
      label: json['label'],
      emoji: json['emoji'],
      description: json['description'],
      exampleComment: json['exampleComment'],
    );
  }
}
