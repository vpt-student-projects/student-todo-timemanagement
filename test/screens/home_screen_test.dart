import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/screens/main_screen.dart';

void main() {
  testWidgets('HomeScreen displays timer', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    
    // Проверяем наличие таймера
    expect(find.text('25:00'), findsOneWidget);
    
    // Проверяем наличие кнопок
    expect(find.text('СТАРТ'), findsOneWidget);
    expect(find.text('СБРОС'), findsOneWidget);
    
    // Проверяем текст цикла
    expect(find.text('Цикл 1 из 4'), findsOneWidget);
  });

  testWidgets('HomeScreen timer buttons exist', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    
    // Проверяем навигационные кнопки
    expect(find.text('Задачи'), findsOneWidget);
    expect(find.text('Прогресс'), findsOneWidget);
    
    // Проверяем иконки
    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.byIcon(Icons.show_chart), findsOneWidget);
  });

  testWidgets('Start button changes to pause', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    
    // Нажимаем СТАРТ
    await tester.tap(find.text('СТАРТ'));
    await tester.pump();
    
    // Должна появиться кнопка ПАУЗА
    expect(find.text('ПАУЗА'), findsOneWidget);
    expect(find.text('СТАРТ'), findsNothing);
  });
}