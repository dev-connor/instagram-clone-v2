import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/instagram_mark.dart';
import 'profile_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() => _submitting = true);
    final auth = context.read<AuthProvider>();
    final error = auth.signup(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
    );
    setState(() => _submitting = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const InstagramMark(size: 72),
              const SizedBox(height: 8),
              const Text(
                '새 계정 만들기',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(hintText: '성명'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: '사용자 이름'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: '이메일 주소'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '비밀번호'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _handleSignup,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('가입'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
