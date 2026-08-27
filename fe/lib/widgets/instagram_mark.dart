import 'package:flutter/material.dart';

class InstagramMark extends StatelessWidget {
  final double size;

  const InstagramMark({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8A3AB9),
            Color(0xFFE95950),
            Color(0xFFFCAF45),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }
}
