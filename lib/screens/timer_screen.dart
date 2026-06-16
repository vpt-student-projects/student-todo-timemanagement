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

  bool get isRunning => _isRunning;
  double get circleProgress => _circleController.value;
  int get remainingSeconds => _seconds;
  int get elapsedSeconds => _elapsedSeconds;
  
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;
  
  // Анимации для котика
  late AnimationController _catAnimationController;
  late Animation<double> _catScaleAnimation;
  late Animation<double> _catOpacityAnimation;
  
  final String _workingCatGif = 'https://media.giphy.com/media/VbnUQpnihPSIgIXuZv/giphy.gif';
  final String _restingCatGif = 'https://media.giphy.com/media/l3q2K5jinAlChoCLS/giphy.gif';

  @override
  void initState() {
    super.initState();
    
    _circleController = AnimationController(
      duration: Duration(seconds: _seconds),
      vsync: this,
    );
    
    _circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_circleController);
    
    // Анимация для котика: плавное появление и пульсация
    _catAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _catScaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _catAnimationController, curve: Curves.easeInOut),
    );
    
    _catOpacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _catAnimationController, curve: Curves.easeInOut),
    );
    
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_isRunning && mounted) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
          _elapsedSeconds++;
          
          final totalSeconds = _isWorkTime ? 25 * 60 : 5 * 60;
          final progress = (_elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
          _circleController.value = progress;
          
        } else {
          _isRunning = false;
          if (_isWorkTime) {
            widget.onPomodoroCompleted();
            widget.onFocusTimeAdded(_elapsedSeconds);
            _elapsedSeconds = 0;
            
            // Эффект вибрации при завершении
          }
          _isWorkTime = !_isWorkTime;
          _seconds = _isWorkTime ? 25 * 60 : 5 * 60;
          
          _circleController.reset();
          _circleController.duration = Duration(seconds: _seconds);
          _elapsedSeconds = 0;
        }
      });
    }
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
    if (_isRunning) {
      // Легкая пульсация при запуске
    }
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _seconds = _isWorkTime ? 25 * 60 : 5 * 60;
      _elapsedSeconds = 0;
      _circleController.reset();
      _circleController.duration = Duration(seconds: _seconds);
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
    _catAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Спокойная цветовая схема
    final workColor = isDarkMode ? Color(0xFF6C9EBF) : Color(0xFF7EB2C4);
    final breakColor = isDarkMode ? Color(0xFF8FB89E) : Color(0xFFA8C9A5);
    final gradientStart = isDarkMode ? Color(0xFF2D3A3E) : Color(0xFFE8F0F2);
    final gradientEnd = isDarkMode ? Color(0xFF1A2528) : Color(0xFFD5E5E8);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStart, gradientEnd],
        ),
      ),
      child: Column(
        children: [
          // Стильный дропдаун для выбора задачи
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800]!.withOpacity(0.8) : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButton<String>(
              value: _selectedTask,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.task_alt, size: 20, color: workColor),
                    const SizedBox(width: 8),
                    Text(
                      widget.localizations.selectTask,
                      style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              icon: Icon(Icons.keyboard_arrow_down, color: workColor),
              items: widget.tasks.map((String task) {
                return DropdownMenuItem<String>(
                  value: task,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      task,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
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
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Статус с индикатором
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: (_isWorkTime ? workColor : breakColor).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isWorkTime ? workColor : breakColor,
                          boxShadow: [
                            BoxShadow(
                              color: (_isWorkTime ? workColor : breakColor).withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isWorkTime ? widget.localizations.workTime : widget.localizations.breakTime,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isWorkTime ? workColor : breakColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Время с красивым шрифтом
                Text(
                  _formatTime(_seconds),
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'monospace',
                    letterSpacing: 4,
                    color: isDarkMode ? Colors.white : Color(0xFF2C3E3A),
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Анимированный круг с котиком
                AnimatedBuilder(
                  animation: _catScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isRunning ? _catScaleAnimation.value : 1.0,
                      child: Opacity(
                        opacity: _isRunning ? _catOpacityAnimation.value : 1.0,
                        child: SizedBox(
                          width: 260,
                          height: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Прогресс круг
                              AnimatedBuilder(
                                animation: _circleAnimation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: const Size(260, 260),
                                    painter: ModernCircleTimerPainter(
                                      progress: _circleAnimation.value,
                                      workColor: workColor,
                                      breakColor: breakColor,
                                      isWorkTime: _isWorkTime,
                                    ),
                                  );
                                },
                              ),
                              
                              // Фоновый круг для гифки
                              Container(
                                width: 190,
                                height: 190,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Котик с анимацией появления
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: ClipOval(
                                  child: Image.network(
                                    key: ValueKey(_isWorkTime),
                                    _isWorkTime ? _workingCatGif : _restingCatGif,
                                    width: 170,
                                    height: 170,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 170,
                                        height: 170,
                                        decoration: BoxDecoration(
                                          color: (_isWorkTime ? workColor : breakColor).withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2,
                                            color: _isWorkTime ? workColor : breakColor,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [_isWorkTime ? workColor : breakColor, (_isWorkTime ? workColor : breakColor).withOpacity(0.6)],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _isWorkTime ? Icons.work : Icons.coffee,
                                            size: 60,
                                            color: Colors.white,
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
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Современные кнопки
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildModernButton(
                      onPressed: _toggleTimer,
                      icon: _isRunning ? Icons.pause : Icons.play_arrow,
                      label: _isRunning ? widget.localizations.pause : widget.localizations.start,
                      color: _isRunning ? Colors.orange : Colors.green,
                      isPrimary: true,
                    ),
                    const SizedBox(width: 20),
                    _buildModernButton(
                      onPressed: _resetTimer,
                      icon: Icons.refresh,
                      label: widget.localizations.reset,
                      color: Colors.red,
                      isPrimary: false,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Текущая задача с анимацией
                if (_selectedTask != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (_isWorkTime ? workColor : breakColor).withOpacity(0.15),
                          (_isWorkTime ? workColor : breakColor).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: (_isWorkTime ? workColor : breakColor).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fiber_manual_record,
                          size: 12,
                          color: _isWorkTime ? workColor : breakColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${widget.localizations.currentTask}:',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTask!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isWorkTime ? workColor : breakColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: isPrimary ? null : Border.all(color: color, width: 2),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : color, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Обновленный кастомный painter
class ModernCircleTimerPainter extends CustomPainter {
  final double progress;
  final Color workColor;
  final Color breakColor;
  final bool isWorkTime;
  
  const ModernCircleTimerPainter({
    required this.progress,
    required this.workColor,
    required this.breakColor,
    required this.isWorkTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    
    // Фоновый круг с градиентом
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Основной прогресс-круг с градиентом
    final gradientColors = isWorkTime
        ? [workColor, workColor.withOpacity(0.6)]
        : [breakColor, breakColor.withOpacity(0.6)];
    
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: -pi / 2 + 2 * pi,
        colors: [gradientColors[0], gradientColors[1], gradientColors[0]],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = 2 * pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
    
    // Декоративная точка в конце прогресса
    if (progress > 0 && progress < 0.99) {
      final angle = -pi / 2 + sweepAngle;
      final pointX = center.dx + radius * cos(angle);
      final pointY = center.dy + radius * sin(angle);
      
      final dotPaint = Paint()
        ..color = isWorkTime ? workColor : breakColor
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(pointX, pointY), 6, dotPaint);
      
      // Внешнее свечение точки
      final glowPaint = Paint()
        ..color = (isWorkTime ? workColor : breakColor).withOpacity(0.4)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawCircle(Offset(pointX, pointY), 12, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ModernCircleTimerPainter oldDelegate) {
    return progress != oldDelegate.progress ||
           workColor != oldDelegate.workColor ||
           breakColor != oldDelegate.breakColor ||
           isWorkTime != oldDelegate.isWorkTime;
  }
}