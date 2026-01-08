class Mood {
  final int? id;
  final String mood;
  final int moodLevel;
  final String category;
  final String date;
  final String? imagePath;

  Mood({
    this.id,
    required this.mood,
    required this.moodLevel,
    required this.category,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'mood_level': moodLevel,
      'category': category,
      'date': date,
      'image_path': imagePath,
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'],
      mood: map['mood'],
      moodLevel: map['mood_level'] ?? 3,
      category: map['category'] ?? '',
      date: map['date'],
      imagePath: map['image_path'],
    );
  }
}
