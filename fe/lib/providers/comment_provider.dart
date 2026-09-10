import 'package:flutter/foundation.dart';

import '../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  final List<Comment> _comments = [];

  /// 특정 게시물의 댓글 목록을 오래된 순으로 반환한다.
  List<Comment> commentsByPost(String postId) {
    final list = _comments.where((c) => c.postId == postId).toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  /// 특정 게시물의 댓글 개수를 반환한다.
  int commentCountByPost(String postId) =>
      _comments.where((c) => c.postId == postId).length;

  /// 게시물에 댓글을 추가한다. 빈 문자열이면 무시한다.
  void addComment({
    required String postId,
    required String authorUsername,
    required String text,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _comments.add(
      Comment(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        postId: postId,
        authorUsername: authorUsername,
        text: trimmed,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  /// 댓글을 삭제한다.
  void deleteComment(String commentId) {
    _comments.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }
}
