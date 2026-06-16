import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/screens/tasks_screen.dart';
import 'package:pomo/app_localizations.dart';

void main() {
  final testTasks = ['Task 1', 'Task 2', 'Task 3'];
  final testCategories = {
    'Task 1': 'urgent-important',
    'Task 2': 'not-urgent-important',
    'Task 3': 'urgent-not-important',
  };
  final testCompletion = {
    'Task 1': false,
    'Task 2': true,
    'Task 3': false,
  };
  final localizations = AppLocalizations('en');

  testWidgets('TasksScreen displays categories', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TasksScreen(
            tasks: testTasks,
            taskCategories: testCategories,
            taskCompletion: testCompletion,
            onTaskAdded: (task) {},
            onTaskDeleted: (task) {},
            onTaskCategoryUpdate: (task, category) {},
            onTaskCompletionToggle: (task) {},
            localizations: localizations,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Проверяем наличие заголовков категорий
    expect(find.text('Urgent & Important'), findsOneWidget);
    expect(find.text('Not Urgent & Important'), findsOneWidget);
    expect(find.text('Urgent & Not Important'), findsOneWidget);
    expect(find.text('Not Urgent & Not Important'), findsOneWidget);
    
    // Проверяем наличие задач
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);
  });

  testWidgets('TasksScreen has input field and add button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TasksScreen(
            tasks: testTasks,
            taskCategories: testCategories,
            taskCompletion: testCompletion,
            onTaskAdded: (task) {},
            onTaskDeleted: (task) {},
            onTaskCategoryUpdate: (task, category) {},
            onTaskCompletionToggle: (task) {},
            localizations: localizations,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Проверяем наличие поля ввода
    expect(find.byType(TextField), findsOneWidget);
    
    // Проверяем наличие кнопки добавления
    expect(find.text('Add Task'), findsOneWidget);
  });

  testWidgets('Add task via text field', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TasksScreen(
            tasks: testTasks,
            taskCategories: testCategories,
            taskCompletion: testCompletion,
            onTaskAdded: (task) {},
            onTaskDeleted: (task) {},
            onTaskCategoryUpdate: (task, category) {},
            onTaskCompletionToggle: (task) {},
            localizations: localizations,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Вводим текст в поле
    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Новая задача');
    await tester.pump();
    
    // Проверяем, что текст введен
    expect(find.text('Новая задача'), findsOneWidget);
  });

  testWidgets('Tasks can be marked as completed', (WidgetTester tester) async {
    bool toggled = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TasksScreen(
            tasks: ['Test Task'],
            taskCategories: {'Test Task': 'urgent-important'},
            taskCompletion: {'Test Task': false},
            onTaskAdded: (task) {},
            onTaskDeleted: (task) {},
            onTaskCategoryUpdate: (task, category) {},
            onTaskCompletionToggle: (task) {
              toggled = true;
            },
            localizations: localizations,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Находим чекбокс и нажимаем на него
    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    
    await tester.tap(checkbox);
    await tester.pump();
    
    // Проверяем, что функция была вызвана
    expect(toggled, isTrue);
  });
}