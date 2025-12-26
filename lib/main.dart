import 'package:flutter/material.dart';
import 'package:pomo/screens/main_screen.dart';
import 'package:pomo/models/user.dart';
import 'package:pomo/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _currentUser;
  String _currentLanguage = 'en';
  bool _isDarkMode = false;
  
  void _updateUser(User? user) {
    setState(() {
      _currentUser = user;
      // Сохраняем настройки темы при смене пользователя
      if (user != null) {
        _isDarkMode = user.isDarkMode;
      }
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _currentLanguage = language;
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(language: language);
      }
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(isDarkMode: _isDarkMode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations(_currentLanguage);
    
    return MaterialApp(
      title: localizations.appTitle,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blue[700]!,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.blue[800]!,
          secondary: Colors.blue[600]!,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(
        currentUser: _currentUser,
        currentLanguage: _currentLanguage,
        isDarkMode: _isDarkMode,
        onUserUpdated: _updateUser,
        onLanguageChanged: _changeLanguage,
        onThemeToggled: _toggleTheme,
      ),
    );
  }
}