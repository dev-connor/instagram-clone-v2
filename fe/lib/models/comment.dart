class Comment {
  final String id;
  final String postId;
  final String authorUsername;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.authorUsername,
    required this.text,
    required this.createdAt,
  });
}
