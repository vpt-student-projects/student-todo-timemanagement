import 'package:flutter/material.dart';
import 'package:pomo/app_localizations.dart';

class TasksScreen extends StatefulWidget {
  final List<String> tasks;
  final Map<String, String> taskCategories;
  final Map<String, bool> taskCompletion;
  final Function(String) onTaskAdded;
  final Function(String) onTaskDeleted;
  final Function(String, String) onTaskCategoryUpdate;
  final Function(String) onTaskCompletionToggle;
  final AppLocalizations localizations;
  
  const TasksScreen({
    super.key,
    required this.tasks,
    required this.taskCategories,
    required this.taskCompletion,
    required this.onTaskAdded,
    required this.onTaskDeleted,
    required this.onTaskCategoryUpdate,
    required this.onTaskCompletionToggle,
    required this.localizations,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;
    
    final task = _taskController.text.trim();
    widget.onTaskAdded(task);
    
    _taskController.clear();
    FocusScope.of(context).unfocus();
  }

  void _deleteTask(String task) {
    widget.onTaskDeleted(task);
  }

  void _updateTaskCategory(String task, String category) {
    widget.onTaskCategoryUpdate(task, category);
  }

  void _toggleTaskCompletion(String task) {
    widget.onTaskCompletionToggle(task);
  }

  List<String> _getTasksByCategory(String category) {
    return widget.tasks.where((task) => widget.taskCategories[task] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Спокойные цвета для матрицы
    final matrixColors = {
      'urgent-important': Colors.red,
      'not-urgent-important': Color(0xFF4A9E6E),
      'urgent-not-important': Color(0xFFE8A34A),
      'not-urgent-not-important': Color(0xFF5B8FB9),
    };
    
    final matrixBgColors = {
      'urgent-important': isDarkMode ? Color(0xFF4A2A2A) : Color(0xFFFFF0F0),
      'not-urgent-important': isDarkMode ? Color(0xFF2A4A35) : Color(0xFFF0FFF4),
      'urgent-not-important': isDarkMode ? Color(0xFF4A3A2A) : Color(0xFFFFF8F0),
      'not-urgent-not-important': isDarkMode ? Color(0xFF2A3A4A) : Color(0xFFF0F8FF),
    };
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [Color(0xFF2D3A3E), Color(0xFF1A2528)]
                : [Color(0xFFF0F6F8), Color(0xFFE5F0F5)],
          ),
        ),
        child: Column(
          children: [
            // Стильное поле для добавления задачи
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800]!.withOpacity(0.9) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: widget.localizations.enterTaskTitle,
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7EB2C4), Color(0xFF5B8FB9)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _addTask,
                    ),
                  ),
                ],
              ),
            ),
            
            // Заголовок матрицы
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Text(
                    widget.localizations.eisenhowerMatrix,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Color(0xFF2C3E3A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.localizations.dragTasks,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Матрица 2x2
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildModernMatrixCell(
                              title: widget.localizations.urgentImportant,
                              category: 'urgent-important',
                              color: matrixColors['urgent-important']!,
                              bgColor: matrixBgColors['urgent-important']!,
                              icon: Icons.warning,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildModernMatrixCell(
                              title: widget.localizations.notUrgentImportant,
                              category: 'not-urgent-important',
                              color: matrixColors['not-urgent-important']!,
                              bgColor: matrixBgColors['not-urgent-important']!,
                              icon: Icons.star,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildModernMatrixCell(
                              title: widget.localizations.urgentNotImportant,
                              category: 'urgent-not-important',
                              color: matrixColors['urgent-not-important']!,
                              bgColor: matrixBgColors['urgent-not-important']!,
                              icon: Icons.timer,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildModernMatrixCell(
                              title: widget.localizations.notUrgentNotImportant,
                              category: 'not-urgent-not-important',
                              color: matrixColors['not-urgent-not-important']!,
                              bgColor: matrixBgColors['not-urgent-not-important']!,
                              icon: Icons.cloud,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernMatrixCell({
    required String title,
    required String category,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    final categoryTasks = _getTasksByCategory(category);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        _updateTaskCategory(details.data, category);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgColor, bgColor.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Заголовок категории
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Список задач
              Expanded(
                child: categoryTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 24, color: color.withOpacity(0.4)),
                            const SizedBox(height: 4),
                            Text(
                              'Перетащите задачу',
                              style: TextStyle(
                                fontSize: 10,
                                color: color.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(6),
                        itemCount: categoryTasks.length,
                        itemBuilder: (context, index) {
                          final task = categoryTasks[index];
                          final isCompleted = widget.taskCompletion[task] ?? false;
                          
                          return Draggable<String>(
                            data: task,
                            feedback: Material(
                              child: _buildTaskCard(task, isCompleted, color, isDarkMode, true),
                            ),
                            child: _buildTaskCard(task, isCompleted, color, isDarkMode, false),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(String task, bool isCompleted, Color color, bool isDarkMode, bool isDragging) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isCompleted
            ? (isDarkMode ? Colors.grey[800] : Colors.grey[100])
            : (isDarkMode ? Colors.grey[700]!.withOpacity(0.8) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
        border: Border.all(
          color: isCompleted ? Colors.grey.withOpacity(0.3) : color.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Checkbox(
            value: isCompleted,
            onChanged: (value) => _toggleTaskCompletion(task),
            activeColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        title: Text(
          task,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            color: isCompleted
                ? Colors.grey
                : (isDarkMode ? Colors.white : Colors.grey[800]),
            fontWeight: isCompleted ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
            onPressed: () => _deleteTask(task),
          ),
        ),
      ),
    );
  }
}