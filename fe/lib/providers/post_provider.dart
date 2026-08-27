import 'package:flutter/foundation.dart';

import '../models/post.dart';

class PostProvider extends ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> postsByUser(String username) {
    final list = _posts.where((p) => p.authorUsername == username).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int postCountByUser(String username) =>
      _posts.where((p) => p.authorUsername == username).length;

  void addPost({
    required String authorUsername,
    required String imagePath,
    required String caption,
  }) {
    _posts.add(
      Post(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        authorUsername: authorUsername,
        imagePath: imagePath,
        caption: caption,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
