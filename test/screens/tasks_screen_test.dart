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

  Widget buildTestWidget({
    List<String>? tasks,
    Map<String, String>? taskCategories,
    Map<String, bool>? taskCompletion,
    Function(String)? onTaskAdded,
    Function(String)? onTaskDeleted,
    Function(String, String)? onTaskCategoryUpdate,
    Function(String)? onTaskCompletionToggle,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: TasksScreen(
          tasks: tasks ?? testTasks,
          taskCategories: taskCategories ?? testCategories,
          taskCompletion: taskCompletion ?? testCompletion,
          onTaskAdded: onTaskAdded ?? (task) {},
          onTaskDeleted: onTaskDeleted ?? (task) {},
          onTaskCategoryUpdate: onTaskCategoryUpdate ?? (task, category) {},
          onTaskCompletionToggle: onTaskCompletionToggle ?? (task) {},
          localizations: localizations,
        ),
      ),
    );
  }

  testWidgets('TasksScreen displays categories', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump(const Duration(milliseconds: 300));
    
    expect(find.text('Urgent & Important'), findsOneWidget);
    expect(find.text('Not Urgent & Important'), findsOneWidget);
    expect(find.text('Urgent & Not Important'), findsOneWidget);
    expect(find.text('Not Urgent & Not Important'), findsOneWidget);
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);
  });

  testWidgets('Tasks can be marked as completed', (WidgetTester tester) async {
    bool toggled = false;
    String? toggledTask;
    
    await tester.pumpWidget(
      buildTestWidget(
        tasks: ['Test Task'],
        taskCategories: {'Test Task': 'urgent-important'},
        taskCompletion: {'Test Task': false},
        onTaskCompletionToggle: (task) {
          toggled = true;
          toggledTask = task;
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    
    expect(find.text('Test Task'), findsOneWidget);
    
    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    
    await tester.tap(checkbox);
    await tester.pump();
    
    expect(toggled, isTrue);
    expect(toggledTask, equals('Test Task'));
  });

  testWidgets('TasksScreen handles empty task list', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        tasks: [],
        taskCategories: {},
        taskCompletion: {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    
    expect(find.text('Urgent & Important'), findsOneWidget);
    expect(find.text('Not Urgent & Important'), findsOneWidget);
    expect(find.text('Urgent & Not Important'), findsOneWidget);
    expect(find.text('Not Urgent & Not Important'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}