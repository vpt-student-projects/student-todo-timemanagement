import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/app_localizations.dart';
import 'package:pomo/screens/timer_screen.dart';

// Мок для AppLocalizations
class MockAppLocalizations extends AppLocalizations {
  MockAppLocalizations() : super('en');
  
  @override
  String get selectTask => 'Select a task';
  @override
  String get workTime => 'Work Time';
  @override
  String get breakTime => 'Break Time';
  @override
  String get start => 'Start';
  @override
  String get pause => 'Pause';
  @override
  String get reset => 'Reset';
  @override
  String get currentTask => 'Current task';
  @override
  String get noTasks => 'No tasks';
  @override
  String get timer => 'Timer';
  @override
  String get tasks => 'Tasks';
  @override
  String get calendar => 'Calendar';
  @override
  String get newTask => 'New Task';
  @override
  String get enterTaskTitle => 'Enter task title...';
  @override
  String get addTask => 'Add Task';
  @override
  String get eisenhowerMatrix => 'Eisenhower Matrix';
  @override
  String get dragTasks => 'Drag tasks between categories';
  @override
  String get urgentImportant => 'Urgent & Important';
  @override
  String get notUrgentImportant => 'Not Urgent & Important';
  @override
  String get urgentNotImportant => 'Urgent & Not Important';
  @override
  String get notUrgentNotImportant => 'Not Urgent & Not Important';
  @override
  String get today => 'Today';
  @override
  String get currentStreak => 'Current streak';
  @override
  String get days => 'days';
  @override
  String get statistics => 'Statistics';
  @override
  String get pomodorosCompleted => 'Pomodoros completed';
  @override
  String get tasksFinished => 'Tasks finished';
  @override
  String get totalFocusTime => 'Total focus time';
  @override
  String get account => 'Account';
  @override
  String get guest => 'Guest';
  @override
  String get notLoggedIn => 'Not logged in';
  @override
  String get language => 'Language';
  @override
  String get theme => 'Theme';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get profileSettings => 'Profile Settings';
  @override
  String get editProfile => 'Edit Profile';
  @override
  String get logout => 'Logout';
  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get username => 'Username';
  @override
  String get cancel => 'Cancel';
  @override
  String get save => 'Save';
  @override
  String get birthDate => 'Birth Date (YYYY-MM-DD)';
  @override
  String get mon => 'Mon';
  @override
  String get tue => 'Tue';
  @override
  String get wed => 'Wed';
  @override
  String get thu => 'Thu';
  @override
  String get fri => 'Fri';
  @override
  String get sat => 'Sat';
  @override
  String get sun => 'Sun';
}

void main() {
  group('TimerScreen Tests', () {
    late List<String> testTasks;
    late Map<String, String> testCategories;
    late bool pomodoroCompletedCalled;
    late int focusTimeAdded;

    setUp(() {
      testTasks = ['Task 1', 'Task 2', 'Task 3'];
      testCategories = {
        'Task 1': 'Work',
        'Task 2': 'Personal',
        'Task 3': 'Study',
      };
      pomodoroCompletedCalled = false;
      focusTimeAdded = 0;
    });

    // Вспомогательная функция для создания виджета с большим экраном
    Widget buildTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            width: 800,
            height: 1200, // Большая высота
            child: TimerScreen(
              tasks: testTasks,
              taskCategories: testCategories,
              onTaskCategoryUpdate: (task, category) {},
              onPomodoroCompleted: () {
                pomodoroCompletedCalled = true;
              },
              onFocusTimeAdded: (int seconds) {
                focusTimeAdded = seconds;
              },
              localizations: MockAppLocalizations(),
            ),
          ),
        ),
      );
    }

    testWidgets('Start button should start the timer when pressed', 
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(const Duration(milliseconds: 500));

        // Initial state
        expect(find.text('25:00'), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        
        // Используем tap с координатами
        final startFinder = find.text('Start');
        expect(startFinder, findsOneWidget);
        
        // Прокручиваем к кнопке
        await tester.ensureVisible(startFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        // Tap Start
        await tester.tap(startFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        // Проверяем Pause
        expect(find.text('Pause'), findsOneWidget);
      },
    );

    testWidgets('Start button should toggle to Pause and back', 
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(const Duration(milliseconds: 500));

        // Tap Start
        final startFinder = find.text('Start');
        await tester.ensureVisible(startFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        await tester.tap(startFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('Pause'), findsOneWidget);
        
        // Tap Pause
        final pauseFinder = find.text('Pause');
        await tester.ensureVisible(pauseFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        await tester.tap(pauseFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('Start'), findsOneWidget);
      },
    );

    testWidgets('Reset button should stop timer and reset to initial state', 
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(const Duration(milliseconds: 500));

        // Start timer
        final startFinder = find.text('Start');
        await tester.ensureVisible(startFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        await tester.tap(startFinder);
        await tester.pump(const Duration(seconds: 2));
        
        // Tap Reset
        final resetFinder = find.text('Reset');
        await tester.ensureVisible(resetFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        await tester.tap(resetFinder);
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('25:00'), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
      },
    );

    testWidgets('Task selection should work with dropdown', 
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(const Duration(milliseconds: 500));

        final dropdown = find.byType(DropdownButton<String>);
        expect(dropdown, findsOneWidget);
        
        // Прокручиваем к dropdown
        await tester.ensureVisible(dropdown);
        await tester.pump(const Duration(milliseconds: 500));
        
        await tester.tap(dropdown);
        await tester.pump(const Duration(milliseconds: 500));
        
        await tester.tap(find.text('Task 1').first);
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.textContaining('Task 1'), findsWidgets);
      },
    );
  });
}