import 'package:flutter/material.dart';
import 'package:pomo/app_localizations.dart';
import 'package:pomo/models/user.dart';
import 'package:pomo/screens/timer_screen.dart';
import 'package:pomo/screens/tasks_screen.dart';
import 'package:pomo/screens/calendar_screen.dart';
import 'package:pomo/widgets/menu_widget.dart';

class MainScreen extends StatefulWidget {
  final User? currentUser;
  final String currentLanguage;
  final bool isDarkMode;
  final Function(User?) onUserUpdated;
  final Function(String) onLanguageChanged;
  final VoidCallback onThemeToggled;

  const MainScreen({
    super.key,
    required this.currentUser,
    required this.currentLanguage,
    required this.isDarkMode,
    required this.onUserUpdated,
    required this.onLanguageChanged,
    required this.onThemeToggled,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<String> _tasks = [];
  final Map<String, String> _taskCategories = {};
  final Map<String, bool> _taskCompletion = {};
  final Set<DateTime> _activeDates = {};
  int _completedPomodoros = 0;
  int _completedTasks = 0;
  int _totalFocusTime = 0;
  
  bool _isMenuOpen = false;

  AppLocalizations get _localizations => AppLocalizations(widget.currentLanguage);

  @override
  void initState() {
    super.initState();
    _addActiveDate(DateTime.now());
  }

  void _addActiveDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    setState(() {
      _activeDates.add(normalizedDate);
    });
  }

  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
      _taskCategories[task] = 'urgent-important';
      _taskCompletion[task] = false;
    });
  }

  void _updateTaskCategory(String task, String category) {
    setState(() {
      _taskCategories[task] = category;
    });
  }

  void _deleteTask(String task) {
    setState(() {
      _tasks.remove(task);
      _taskCategories.remove(task);
      _taskCompletion.remove(task);
    });
  }

  void _toggleTaskCompletion(String task) {
    setState(() {
      final wasCompleted = _taskCompletion[task] ?? false;
      _taskCompletion[task] = !wasCompleted;
      if (!wasCompleted) {
        _completedTasks++;
      } else {
        _completedTasks--;
      }
    });
  }

  void _incrementPomodoros() {
    setState(() {
      _completedPomodoros++;
      _addActiveDate(DateTime.now());
    });
  }

  void _addFocusTime(int seconds) {
    setState(() {
      _totalFocusTime += seconds;
    });
  }

  // Методы для меню и пользователя
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _login(String email, String password) {
    final newUser = User(
      id: '1',
      email: email,
      username: email.split('@').first,
      language: widget.currentLanguage,
      isDarkMode: widget.isDarkMode,
    );
    widget.onUserUpdated(newUser);
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _register(String email, String password, String username) {
    final newUser = User(
      id: '1',
      email: email,
      username: username,
      language: widget.currentLanguage,
      isDarkMode: widget.isDarkMode,
    );
    widget.onUserUpdated(newUser);
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _logout() {
    widget.onUserUpdated(null);
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _updateUserProfile(User updatedUser) {
    widget.onUserUpdated(updatedUser.copyWith(isDarkMode: widget.isDarkMode));
  }

  void _changeLanguage(String language) {
    widget.onLanguageChanged(language);
  }

  void _toggleTheme() {
    widget.onThemeToggled();
  }

  int get _currentStreak {
    if (_activeDates.isEmpty) return 0;
    
    final dates = _activeDates.toList()..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime currentDate = DateTime.now();
    final today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    
    for (int i = 0; i < dates.length; i++) {
      final expectedDate = today.subtract(Duration(days: i));
      final normalizedExpected = DateTime(expectedDate.year, expectedDate.month, expectedDate.day);
      
      if (dates.any((date) => date.isAtSameMomentAs(normalizedExpected))) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _toggleMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          _getCurrentScreen(),
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black54,
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: _isMenuOpen ? 0 : -MediaQuery.of(context).size.width / 3,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(-2, 0),
                  ),
                ],
              ),
              child: MenuWidget(
                currentUser: widget.currentUser,
                currentLanguage: widget.currentLanguage,
                isDarkMode: widget.isDarkMode,
                isMenuOpen: _isMenuOpen,
                localizations: _localizations,
                onToggleMenu: _toggleMenu,
                onLogin: _login,
                onRegister: _register,
                onLogout: _logout,
                onChangeLanguage: _changeLanguage,
                onToggleTheme: _toggleTheme,
                onUpdateUserProfile: _updateUserProfile,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.timer),
            label: _localizations.timer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.task),
            label: _localizations.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: _localizations.calendar,
          ),
        ],
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return TimerScreen(
          tasks: _tasks,
          taskCategories: _taskCategories,
          onTaskCategoryUpdate: _updateTaskCategory,
          onPomodoroCompleted: _incrementPomodoros,
          onFocusTimeAdded: _addFocusTime,
          localizations: _localizations,
        );
      case 1:
        return TasksScreen(
          tasks: _tasks,
          taskCategories: _taskCategories,
          taskCompletion: _taskCompletion,
          onTaskAdded: _addTask,
          onTaskDeleted: _deleteTask,
          onTaskCategoryUpdate: _updateTaskCategory,
          onTaskCompletionToggle: _toggleTaskCompletion,
          localizations: _localizations,
        );
      case 2:
        return CalendarScreen(
          activeDates: _activeDates,
          completedPomodoros: _completedPomodoros,
          completedTasks: _completedTasks,
          totalFocusTime: _totalFocusTime,
          currentStreak: _currentStreak,
          localizations: _localizations,
        );
      default:
        return TimerScreen(
          tasks: _tasks,
          taskCategories: _taskCategories,
          onTaskCategoryUpdate: _updateTaskCategory,
          onPomodoroCompleted: _incrementPomodoros,
          onFocusTimeAdded: _addFocusTime,
          localizations: _localizations,
        );
    }
  }
}