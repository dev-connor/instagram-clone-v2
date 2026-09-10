import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../providers/auth_provider.dart';
import '../providers/comment_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final username = context.read<AuthProvider>().currentUser?.username;
    if (username == null) return;

    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    context.read<CommentProvider>().addComment(
          postId: widget.post.id,
          authorUsername: username,
          text: text,
        );
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _confirmDelete(Comment comment) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          '댓글 삭제',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '이 댓글을 삭제할까요?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              context.read<CommentProvider>().deleteComment(comment.id);
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              '삭제',
              style: TextStyle(color: Color(0xFFED4956)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final currentUsername = context.watch<AuthProvider>().currentUser?.username;
    final comments = context.watch<CommentProvider>().commentsByPost(post.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('게시물'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF1C1C1C),
                        child: Icon(Icons.person,
                            color: Colors.white54, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post.authorUsername,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    File(post.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                if (post.caption.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white, height: 1.3),
                        children: [
                          TextSpan(
                            text: '${post.authorUsername} ',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: post.caption),
                        ],
                      ),
                    ),
                  ),
                const Divider(color: Color(0xFF262626), height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '댓글 ${comments.length}개',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                    child: Center(
                      child: Text(
                        '아직 댓글이 없습니다.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  ...comments.map(
                    (comment) => _CommentTile(
                      comment: comment,
                      canDelete: comment.authorUsername == currentUsername,
                      onDelete: () => _confirmDelete(comment),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const Divider(color: Color(0xFF262626), height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _addComment(),
                      decoration: const InputDecoration(
                        hintText: '댓글 달기...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _addComment,
                    child: const Text(
                      '게시',
                      style: TextStyle(
                        color: Color(0xFF0095F6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  final bool canDelete;
  final VoidCallback onDelete;

  const _CommentTile({
    required this.comment,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF1C1C1C),
            child: Icon(Icons.person, color: Colors.white54, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white, height: 1.3),
                children: [
                  TextSpan(
                    text: '${comment.authorUsername} ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: comment.text),
                ],
              ),
            ),
          ),
          if (canDelete)
            GestureDetector(
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.delete_outline,
                    color: Colors.white38, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}
