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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    
    // Спокойная цветовая схема
    final workColor = isDarkMode ? Color(0xFF6C9EBF) : Color(0xFF7EB2C4);
    final breakColor = isDarkMode ? Color(0xFF8FB89E) : Color(0xFFA8C9A5);
    final gradientStart = isDarkMode ? Color(0xFF2D3A3E) : Color(0xFFE8F0F2);
    final gradientEnd = isDarkMode ? Color(0xFF1A2528) : Color(0xFFD5E5E8);
    
    // Размеры круга в зависимости от экрана
    final circleSize = isSmallScreen ? 200.0 : 240.0;
    final catSize = isSmallScreen ? 130.0 : 160.0;
    final fontSize = isSmallScreen ? 48.0 : 64.0;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStart, gradientEnd],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Дропдаун для выбора задачи - уменьшенный
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: isSmallScreen ? 8 : 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.task_alt, size: 18, color: workColor),
                      const SizedBox(width: 6),
                      Text(
                        widget.localizations.selectTask,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                icon: Icon(Icons.keyboard_arrow_down, color: workColor, size: 20),
                items: widget.tasks.map((String task) {
                  return DropdownMenuItem<String>(
                    value: task,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        task,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
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
                  // Статус с индикатором - уменьшенный
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: (_isWorkTime ? workColor : breakColor).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
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
                        const SizedBox(width: 8),
                        Text(
                          _isWorkTime ? widget.localizations.workTime : widget.localizations.breakTime,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: _isWorkTime ? workColor : breakColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 12 : 20),
                  
                  // Время
                  Text(
                    _formatTime(_seconds),
                    style: TextStyle(
                      fontSize: fontSize,
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
                  
                  SizedBox(height: isSmallScreen ? 12 : 20),
                  
                  // Анимированный круг с котиком
                  AnimatedBuilder(
                    animation: _catScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isRunning ? _catScaleAnimation.value : 1.0,
                        child: Opacity(
                          opacity: _isRunning ? _catOpacityAnimation.value : 1.0,
                          child: SizedBox(
                            width: circleSize,
                            height: circleSize,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Прогресс круг
                                AnimatedBuilder(
                                  animation: _circleAnimation,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      size: Size(circleSize, circleSize),
                                      painter: ModernCircleTimerPainter(
                                        progress: _circleAnimation.value,
                                        workColor: workColor,
                                        breakColor: breakColor,
                                        isWorkTime: _isWorkTime,
                                        circleSize: circleSize,
                                      ),
                                    );
                                  },
                                ),
                                
                                // Фоновый круг для гифки
                                Container(
                                  width: circleSize * 0.72,
                                  height: circleSize * 0.72,
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
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Котик
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: ClipOval(
                                    child: Image.network(
                                      key: ValueKey(_isWorkTime),
                                      _isWorkTime ? _workingCatGif : _restingCatGif,
                                      width: catSize,
                                      height: catSize,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          width: catSize,
                                          height: catSize,
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
                                              size: catSize * 0.35,
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
                  
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  
                  // Кнопки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModernButton(
                        onPressed: _toggleTimer,
                        icon: _isRunning ? Icons.pause : Icons.play_arrow,
                        label: _isRunning ? widget.localizations.pause : widget.localizations.start,
                        color: _isRunning ? Colors.orange : Colors.green,
                        isPrimary: true,
                        isSmall: isSmallScreen,
                      ),
                      const SizedBox(width: 12),
                      _buildModernButton(
                        onPressed: _resetTimer,
                        icon: Icons.refresh,
                        label: widget.localizations.reset,
                        color: Colors.red,
                        isPrimary: false,
                        isSmall: isSmallScreen,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: isSmallScreen ? 8 : 16),
                  
                  // Текущая задача
                  if (_selectedTask != null)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: isSmallScreen ? 4 : 8),
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: isSmallScreen ? 6 : 10),
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
                            size: 10,
                            color: _isWorkTime ? workColor : breakColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.localizations.currentTask}:',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 11 : 13,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedTask!,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 11 : 13,
                              fontWeight: FontWeight.w600,
                              color: _isWorkTime ? workColor : breakColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Добавляем отступ внизу для маленьких экранов
                  SizedBox(height: isSmallScreen ? 4 : 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required bool isPrimary,
    required bool isSmall,
  }) {
    final padding = isSmall 
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 28, vertical: 14);
    final iconSize = isSmall ? 16.0 : 20.0;
    final fontSize = isSmall ? 12.0 : 14.0;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
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
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : color, size: iconSize),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernCircleTimerPainter extends CustomPainter {
  final double progress;
  final Color workColor;
  final Color breakColor;
  final bool isWorkTime;
  final double circleSize;
  
  const ModernCircleTimerPainter({
    required this.progress,
    required this.workColor,
    required this.breakColor,
    required this.isWorkTime,
    required this.circleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final strokeWidth = circleSize < 220 ? 6.0 : 8.0;
    final dotSize = circleSize < 220 ? 4.0 : 6.0;
    final glowSize = circleSize < 220 ? 8.0 : 12.0;
    
    // Фоновый круг
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Основной прогресс-круг
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
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = 2 * pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
    
    // Декоративная точка
    if (progress > 0 && progress < 0.99) {
      final angle = -pi / 2 + sweepAngle;
      final pointX = center.dx + radius * cos(angle);
      final pointY = center.dy + radius * sin(angle);
      
      final dotPaint = Paint()
        ..color = isWorkTime ? workColor : breakColor
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(pointX, pointY), dotSize, dotPaint);
      
      final glowPaint = Paint()
        ..color = (isWorkTime ? workColor : breakColor).withOpacity(0.4)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawCircle(Offset(pointX, pointY), glowSize, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ModernCircleTimerPainter oldDelegate) {
    return progress != oldDelegate.progress ||
           workColor != oldDelegate.workColor ||
           breakColor != oldDelegate.breakColor ||
           isWorkTime != oldDelegate.isWorkTime ||
           circleSize != oldDelegate.circleSize;
  }
}