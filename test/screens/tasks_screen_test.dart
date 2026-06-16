import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/screens/tasks_screen.dart';

void main() {
  testWidgets('TasksScreen displays categories', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TasksScreen()));
    
    // Проверяем наличие категорий
    expect(find.text('Важное и срочное'), findsOneWidget);
    expect(find.text('Важное, но не срочное'), findsOneWidget);
    expect(find.text('Не важное, но нужно сделать'), findsOneWidget);
    expect(find.text('Совсем не важное'), findsOneWidget);
  });

  testWidgets('TasksScreen has input field', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TasksScreen()));
    
    // Проверяем наличие поля ввода
    expect(find.byType(TextField), findsOneWidget);
    
    // Проверяем кнопку добавления
    expect(find.byIcon(Icons.add_circle), findsOneWidget);
  });

  testWidgets('Add task via text field', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TasksScreen()));
    
    // Вводим текст в поле
    await tester.enterText(find.byType(TextField), 'Новая задача');
    expect(find.text('Новая задача'), findsOneWidget);
  });
}