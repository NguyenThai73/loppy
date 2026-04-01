class Comment {
  final String author;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.author,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class Post {
  final String id;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  int likeCount;
  bool isLiked;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.content,
    this.imageUrl,
    DateTime? createdAt,
    this.likeCount = 0,
    this.isLiked = false,
    List<Comment>? comments,
  })  : createdAt = createdAt ?? DateTime.now(),
        comments = comments ?? [];
}
