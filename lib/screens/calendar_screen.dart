import 'package:flutter/material.dart';
import 'package:pomo/app_localizations.dart';

class CalendarScreen extends StatelessWidget {
  final Set<DateTime> activeDates;
  final int completedPomodoros;
  final int completedTasks;
  final int totalFocusTime;
  final int currentStreak;
  final AppLocalizations localizations;
  
  const CalendarScreen({
    super.key,
    required this.activeDates,
    required this.completedPomodoros,
    required this.completedTasks,
    required this.totalFocusTime,
    required this.currentStreak,
    required this.localizations,
  });

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    List<Widget> dayWidgets = [];
    
    int startingWeekday = firstDayOfMonth.weekday;
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }
    
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final currentDate = DateTime(now.year, now.month, day);
      final isActive = activeDates.any((date) => 
        date.year == currentDate.year && 
        date.month == currentDate.month && 
        date.day == currentDate.day
      );
      final isToday = day == now.day;
      
      Color? backgroundColor;
      Color textColor;
      
      if (isActive) {
        backgroundColor = Colors.amber;
        textColor = Colors.black;
      } else if (isToday) {
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
      } else {
        backgroundColor = Colors.transparent;
        textColor = Colors.black;
      }
      
      dayWidgets.add(
        Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (isActive)
                  const Icon(Icons.check, size: 12, color: Colors.green),
              ],
            ),
          ),
        ),
      );
    }
    
    return Column(
      children: [
        Text(
          '${localizations.getMonthName(now.month)} ${now.year}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          children: _buildWeekdayHeaders(),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: dayWidgets,
        ),
      ],
    );
  }

  List<Widget> _buildWeekdayHeaders() {
    return [
      Text(localizations.mon, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(localizations.tue, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(localizations.wed, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(localizations.thu, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(localizations.fri, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(localizations.sat, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(localizations.sun, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
    ];
  }

  String _formatFocusTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      localizations.today,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${localizations.currentStreak}: $currentStreak ${localizations.days}',
                      style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.calendar,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildCalendar(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.statistics,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatItem(localizations.pomodorosCompleted, completedPomodoros.toString()),
                    _buildStatItem(localizations.tasksFinished, completedTasks.toString()),
                    _buildStatItem(localizations.totalFocusTime, _formatFocusTime(totalFocusTime)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}