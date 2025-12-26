class User {
  final String id;
  final String email;
  final String username;
  final DateTime? birthDate;
  final String language;
  final bool isDarkMode;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.birthDate,
    this.language = 'en',
    this.isDarkMode = false,
  });

  User copyWith({
    String? username,
    DateTime? birthDate,
    String? language,
    bool? isDarkMode,
  }) {
    return User(
      id: id,
      email: email,
      username: username ?? this.username,
      birthDate: birthDate ?? this.birthDate,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}