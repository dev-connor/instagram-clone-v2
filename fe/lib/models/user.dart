class AppUser {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String? profileImagePath;

  AppUser({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.profileImagePath,
  });
}
