import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pomo/app_localizations.dart';

class TimerScreen extends StatefulWidget {
  final List<String> tasks;
  final Map<String, String> taskCategories;
  final Function(String, String) onTaskCategoryUpdate;
  final VoidCallback onPomodoroCompleted;
  final Function(int) onFocusTimeAdded;
  final AppLocalizations localizations;
  
  const TimerScreen({
    super.key,
    required this.tasks,
    required this.taskCategories,
    required this.onTaskCategoryUpdate,
    required this.onPomodoroCompleted,
    required this.onFocusTimeAdded,
    required this.localizations,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  int _seconds = 25 * 60;
  bool _isRunning = false;
  bool _isWorkTime = true;
  String? _selectedTask;
  late Timer _timer;
  int _elapsedSeconds = 0;
  
  // Для анимации круга
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;
  
  // URL GIF
  final String _workingCatGif = 'https://media.giphy.com/media/VbnUQpnihPSIgIXuZv/giphy.gif';
  final String _restingCatGif = 'https://media.giphy.com/media/l3q2K5jinAlChoCLS/giphy.gif';

  @override
  void initState() {
    super.initState();
    
    // Инициализация контроллера для круга
    _circleController = AnimationController(
      duration: Duration(seconds: _seconds),
      vsync: this,
    );
    
    _circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_circleController);
    
    // Запускаем таймер для обновления
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_isRunning && mounted) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
          _elapsedSeconds++;
          
          // Обновляем анимацию круга
          final progress = (_elapsedSeconds / (_isWorkTime ? 25 * 60 : 5 * 60));
          _circleController.value = progress;
          
        } else {
          _isRunning = false;
          if (_isWorkTime) {
            widget.onPomodoroCompleted();
            widget.onFocusTimeAdded(_elapsedSeconds);
            _elapsedSeconds = 0;
          }
          _isWorkTime = !_isWorkTime;
          _seconds = _isWorkTime ? 25 * 60 : 5 * 60;
          
          // Сбрасываем анимацию круга
          _circleController.reset();
          _elapsedSeconds = 0;
        }
      });
    }
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _seconds = _isWorkTime ? 25 * 60 : 5 * 60;
      _elapsedSeconds = 0;
      _circleController.reset();
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final circleColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    
    // Определяем цвета для контейнера задачи
    final workTaskBgColor = isDarkMode ? Colors.blue.shade900 : Colors.blue.shade50;
    final breakTaskBgColor = isDarkMode ? Colors.green.shade900 : Colors.green.shade50;
    final workTaskTextColor = isDarkMode ? Colors.blue.shade100 : Colors.blue.shade800;
    final breakTaskTextColor = isDarkMode ? Colors.green.shade100 : Colors.green.shade800;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: DropdownButton<String>(
              value: _selectedTask,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.localizations.selectTask,
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[700]),
                ),
              ),
              isExpanded: true,
              underline: Container(), // Убираем стандартную линию
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              items: widget.tasks.map((String task) {
                return DropdownMenuItem<String>(
                  value: task,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      task,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTask = newValue;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заголовок с временем
              Text(
                '${_isWorkTime ? widget.localizations.workTime : widget.localizations.breakTime}: ${_formatTime(_seconds)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isWorkTime ? Colors.blue : Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              
              // Контейнер с анимированным кругом и гифкой
              SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Внешний круг с анимацией отсчета
                    AnimatedBuilder(
                      animation: _circleAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(250, 250),
                          painter: CircleTimerPainter(
                            progress: _circleAnimation.value,
                            color: circleColor,
                            isWorkTime: _isWorkTime,
                          ),
                        );
                      },
                    ),
                    
                    // Внутренний круг для фона гифки
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    
                    // GIF котика
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          _isWorkTime ? _workingCatGif : _restingCatGif,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback если GIF не загрузился
                            return Container(
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  _isWorkTime ? Icons.work : Icons.coffee,
                                  size: 60,
                                  color: _isWorkTime ? Colors.blue : Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Кнопки управления
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(_isRunning ? widget.localizations.pause : widget.localizations.start),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(widget.localizations.reset),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Текущая задача
              if (_selectedTask != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isWorkTime ? workTaskBgColor : breakTaskBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isWorkTime ? Colors.blue : Colors.green,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${widget.localizations.currentTask}: $_selectedTask',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: _isWorkTime ? workTaskTextColor : breakTaskTextColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Кастомный painter для анимированного круга
class CircleTimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isWorkTime;
  
  const CircleTimerPainter({
    required this.progress,
    required this.color,
    required this.isWorkTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    
    // Фоновый круг
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Прогресс-круг
    final progressPaint = Paint()
      ..color = isWorkTime ? Colors.blue : Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    
    // Рассчитываем угол для прогресса (от 0 до 360 градусов)
    final sweepAngle = 2 * pi * progress;
    
    // Рисуем дугу прогресса (начинаем сверху)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Начинаем сверху
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircleTimerPainter oldDelegate) {
    return progress != oldDelegate.progress ||
           color != oldDelegate.color ||
           isWorkTime != oldDelegate.isWorkTime;
  }
}