import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import 'login_screen.dart';
import 'post_image_select_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final posts = context.watch<PostProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final userPosts = posts.postsByUser(user.username);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add_box_outlined),
          tooltip: '새 게시물',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PostImageSelectScreen()),
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user.username),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF1C1C1C),
                  child: Icon(Icons.person, color: Colors.white54, size: 40),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${userPosts.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      '게시물',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF262626), height: 1),
          Expanded(
            child: userPosts.isEmpty
                ? const Center(
                    child: Text(
                      '게시물이 없습니다.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) {
                      final post = userPosts[index];
                      return Image.file(
                        File(post.imagePath),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
