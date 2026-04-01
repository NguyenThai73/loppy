class Note {
  final String id;
  String title;
  bool isDone;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
