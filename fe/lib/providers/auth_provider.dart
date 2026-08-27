import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final List<AppUser> _users = [
    AppUser(
      username: 'testuser',
      email: 'test@test.com',
      password: '123456',
      fullName: '테스트 사용자',
    ),
  ];

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  String? signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return '모든 필드를 입력해 주세요.';
    }
    if (_users.any((u) => u.username == username)) {
      return '이미 사용 중인 사용자 이름입니다.';
    }
    if (_users.any((u) => u.email == email)) {
      return '이미 사용 중인 이메일입니다.';
    }
    final user = AppUser(
      username: username,
      email: email,
      password: password,
      fullName: fullName.isEmpty ? username : fullName,
    );
    _users.add(user);
    _currentUser = user;
    notifyListeners();
    return null;
  }

  String? login({required String identifier, required String password}) {
    final user = _users.firstWhere(
      (u) => (u.username == identifier || u.email == identifier) &&
          u.password == password,
      orElse: () => AppUser(
        username: '',
        email: '',
        password: '',
        fullName: '',
      ),
    );
    if (user.username.isEmpty) {
      return '아이디 또는 비밀번호가 올바르지 않습니다.';
    }
    _currentUser = user;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
