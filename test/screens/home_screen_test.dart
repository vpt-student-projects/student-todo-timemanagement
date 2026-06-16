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

  Widget buildTestWidget() {
    return MaterialApp(
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
    );
  }

  testWidgets('MainScreen displays timer initially', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    
    // ⚡ ВАЖНО: Используем pump() вместо pumpAndSettle()
    // Потому что анимация котика бесконечная
    await tester.pump(const Duration(milliseconds: 500));
    
    // Проверяем наличие таймера
    expect(find.text('25:00'), findsOneWidget);
    
    // Проверяем наличие кнопок
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    
    // Проверяем нижнюю навигацию
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
  });

  testWidgets('MainScreen bottom navigation exists', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump(const Duration(milliseconds: 500));
    
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Start button changes behavior on tap', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump(const Duration(milliseconds: 500));
    
    final startButton = find.text('Start');
    expect(startButton, findsOneWidget);
    
    await tester.tap(startButton);
    await tester.pump(const Duration(milliseconds: 500));
    
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });

  testWidgets('Navigation switches screens', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump(const Duration(milliseconds: 500));
    
    // Нажимаем на вкладку Tasks
    await tester.tap(find.text('Tasks'));
    await tester.pump(const Duration(milliseconds: 500));
    
    expect(find.byType(TextField), findsOneWidget);
    
    // Нажимаем на вкладку Calendar
    await tester.tap(find.text('Calendar'));
    await tester.pump(const Duration(milliseconds: 500));
    
    expect(find.text('Today'), findsOneWidget);
  });
}