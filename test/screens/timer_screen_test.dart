import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/screens/timer_screen.dart'; // Путь к TimerScreen
import 'package:pomo/app_localizations.dart';

void main() {
  late List<String> tasks;
  late Map<String, String> taskCategories;
  late AppLocalizations localizations;

  setUp(() {
    tasks = ['Task 1', 'Task 2'];
    taskCategories = {'Task 1': 'Work', 'Task 2': 'Personal'};
    localizations = AppLocalizations('en');
  });

  testWidgets('Кнопка Старт меняет текст и запускает отсчёт времени', (WidgetTester tester) async {
  final timerScreen = TimerScreen(
    tasks: tasks,
    taskCategories: taskCategories,
    onTaskCategoryUpdate: (task, category) {},
    onPomodoroCompleted: () {},
    onFocusTimeAdded: (seconds) {},
    localizations: localizations,
  );

  await tester.pumpWidget(MaterialApp(home: timerScreen));

  // Проверяем, что изначально видна кнопка «Start»
  expect(find.text(localizations.start), findsOneWidget);
  expect(find.text(localizations.pause), findsNothing);

  // Нажимаем «Start»
  await tester.tap(find.text(localizations.start));
  await tester.pump();

  // Проверяем, что текст кнопки изменился на «Pause»
  expect(find.text(localizations.start), findsNothing);
  expect(find.text(localizations.pause), findsOneWidget);

  // Запоминаем начальное время (25:00)
  final initialTime = '25:00';
  expect(find.text(initialTime), findsOneWidget);

  // Ждём 2 секунды
  await tester.pump(const Duration(seconds: 2));

  // Проверяем, что время обновилось (стало 24:58)
  final updatedTime = '24:58';
  expect(find.text(updatedTime), findsOneWidget);
});


}
