import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/instagram_mark.dart';
import 'profile_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _submitting = true);
    final auth = context.read<AuthProvider>();
    final error = auth.login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 96),
              const InstagramMark(),
              const SizedBox(height: 64),
              TextField(
                controller: _identifierController,
                decoration: const InputDecoration(
                  hintText: '사용자 이름, 이메일 주소 또는 휴대폰 번호',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '비밀번호'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitting ? null : _handleLogin,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('로그인'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('추후 지원될 기능입니다.')),
                  );
                },
                child: const Text(
                  '비밀번호를 잊으셨나요?',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              const SizedBox(height: 48),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text('새 계정 만들기'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
