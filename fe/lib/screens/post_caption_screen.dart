import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import 'profile_screen.dart';

class PostCaptionScreen extends StatefulWidget {
  final File image;

  const PostCaptionScreen({super.key, required this.image});

  @override
  State<PostCaptionScreen> createState() => _PostCaptionScreenState();
}

class _PostCaptionScreenState extends State<PostCaptionScreen> {
  final _captionController = TextEditingController();
  bool _sharing = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    final username = context.read<AuthProvider>().currentUser?.username;
    if (username == null) return;

    setState(() => _sharing = true);
    context.read<PostProvider>().addPost(
          authorUsername: username,
          imagePath: widget.image.path,
          caption: _captionController.text.trim(),
        );

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('새 게시물'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    widget.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    maxLines: 4,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: '캡션 추가...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF262626), height: 1),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _sharing ? null : _share,
              child: _sharing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('공유하기'),
            ),
          ),
        ],
      ),
    );
  }
}
