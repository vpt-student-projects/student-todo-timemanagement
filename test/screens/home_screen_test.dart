import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/screens/main_screen.dart';
import 'package:pomo/models/user.dart';

void main() {
  final testUser = User(
    id: '1',
    email: 'test@example.com',
    username: 'TestUser',
  );

  testWidgets('MainScreen displays timer initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainScreen(
            currentUser: testUser,
            currentLanguage: 'en',
            isDarkMode: false,
            onUserUpdated: (user) {},
            onLanguageChanged: (lang) {},
            onThemeToggled: () {},
          ),
        ),
      ),
    );

    // Ждем завершения анимаций
    await tester.pumpAndSettle();
    
    // Проверяем наличие таймера - ищем текст "25:00" или "Work Time"
    expect(find.text('25:00'), findsOneWidget);
    
    // Проверяем наличие кнопок Start и Reset
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    
    // Проверяем нижнюю навигацию - ищем текст, а не иконки
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
  });

  testWidgets('MainScreen bottom navigation exists', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainScreen(
            currentUser: testUser,
            currentLanguage: 'en',
            isDarkMode: false,
            onUserUpdated: (user) {},
            onLanguageChanged: (lang) {},
            onThemeToggled: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Проверяем наличие нижней навигации по тексту
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    
    // Проверяем, что BottomNavigationBar существует
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Start button changes behavior on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainScreen(
            currentUser: testUser,
            currentLanguage: 'en',
            isDarkMode: false,
            onUserUpdated: (user) {},
            onLanguageChanged: (lang) {},
            onThemeToggled: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Находим кнопку Start
    final startButton = find.text('Start');
    expect(startButton, findsOneWidget);
    
    // Нажимаем на кнопку Start
    await tester.tap(startButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // Ждем обновления
    
    // Кнопка должна измениться на Pause
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });

  testWidgets('Navigation switches screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainScreen(
            currentUser: testUser,
            currentLanguage: 'en',
            isDarkMode: false,
            onUserUpdated: (user) {},
            onLanguageChanged: (lang) {},
            onThemeToggled: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Нажимаем на вкладку Tasks по тексту
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    
    // Проверяем, что отображается экран задач - ищем поле ввода
    expect(find.byType(TextField), findsOneWidget);
    
    // Нажимаем на вкладку Calendar
    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();
    
    // Проверяем, что отображается календарь
    expect(find.text('Today'), findsOneWidget);
  });
}