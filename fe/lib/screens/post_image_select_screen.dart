import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'post_caption_screen.dart';

class PostImageSelectScreen extends StatefulWidget {
  const PostImageSelectScreen({super.key});

  @override
  State<PostImageSelectScreen> createState() => _PostImageSelectScreenState();
}

class _PostImageSelectScreenState extends State<PostImageSelectScreen> {
  File? _selectedImage;
  bool _picking = false;

  Future<void> _pickFromGallery() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _goNext() {
    if (_selectedImage == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostCaptionScreen(image: _selectedImage!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('새 게시물'),
        actions: [
          TextButton(
            onPressed: _selectedImage == null ? null : _goNext,
            child: Text(
              '다음',
              style: TextStyle(
                color: _selectedImage == null
                    ? Colors.white24
                    : const Color(0xFF0095F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    color: const Color(0xFF1C1C1C),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : Center(
                            child: _picking
                                ? const CircularProgressIndicator()
                                : const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add_photo_alternate_outlined,
                                          color: Colors.white54, size: 48),
                                      SizedBox(height: 8),
                                      Text(
                                        '탭하여 사진을 선택하세요',
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    ],
                                  ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Text(
                    '최근 항목',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.expand_more, color: Colors.white, size: 18),
                ],
              ),
            ),
            GridView.builder(
              padding: const EdgeInsets.all(2),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    color: const Color(0xFF1C1C1C),
                    child: const Icon(Icons.image_outlined, color: Colors.white24),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
