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

  Color _getTextColor(BuildContext context, bool isCompleted) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    if (isCompleted) {
      return Colors.grey;
    } else {
      return isDarkMode ? Colors.white : Colors.black;
    }
  }

  Color _getCardColor(BuildContext context, bool isCompleted) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    if (isCompleted) {
      return isDarkMode ? Colors.green[900]! : Colors.green[50]!;
    } else {
      return isDarkMode ? theme.cardColor : theme.cardColor;
    }
  }

  Widget _buildMatrixCell(String title, String category, Color borderColor) {
    final categoryTasks = _getTasksByCategory(category);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        _updateTaskCategory(details.data, category);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode ? Colors.grey[900]! : Colors.white,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: isDarkMode ? Colors.white : borderColor,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryTasks.length,
                  itemBuilder: (context, index) {
                    final task = categoryTasks[index];
                    final isCompleted = widget.taskCompletion[task] ?? false;
                    
                    return Draggable<String>(
                      data: task,
                      feedback: Material(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[800]! : Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            task,
                            style: TextStyle(
                              decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                              color: _getTextColor(context, isCompleted),
                            ),
                          ),
                        ),
                      ),
                      child: Card(
                        color: _getCardColor(context, isCompleted),
                        child: ListTile(
                          title: Text(
                            task,
                            style: TextStyle(
                              decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                              color: _getTextColor(context, isCompleted),
                            ),
                          ),
                          leading: Checkbox(
                            value: isCompleted,
                            onChanged: (value) {
                              _toggleTaskCompletion(task);
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete, 
                              size: 20,
                              color: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
                            ),
                            onPressed: () {
                              _deleteTask(task);
                            },
                          ),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: widget.localizations.newTask,
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : null,
                    ),
                    border: const OutlineInputBorder(),
                    hintText: widget.localizations.enterTaskTitle,
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white54 : null,
                    ),
                    filled: isDarkMode,
                    fillColor: isDarkMode ? Colors.grey[800] : null,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text(widget.localizations.addTask),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.localizations.eisenhowerMatrix} - ${widget.localizations.dragTasks}',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildMatrixCell(widget.localizations.urgentImportant, 'urgent-important', Colors.red),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMatrixCell(widget.localizations.notUrgentImportant, 'not-urgent-important', Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildMatrixCell(widget.localizations.urgentNotImportant, 'urgent-not-important', Colors.orange),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMatrixCell(widget.localizations.notUrgentNotImportant, 'not-urgent-not-important', Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}