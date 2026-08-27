class Post {
  final String id;
  final String authorUsername;
  final String imagePath;
  final String caption;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.authorUsername,
    required this.imagePath,
    required this.caption,
    required this.createdAt,
  });
}
