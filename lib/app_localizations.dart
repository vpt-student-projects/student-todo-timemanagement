class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Pomodoro Timer',
      'timer': 'Timer',
      'tasks': 'Tasks',
      'calendar': 'Calendar',
      'workTime': 'Work Time',
      'breakTime': 'Break Time',
      'start': 'Start',
      'pause': 'Pause',
      'reset': 'Reset',
      'selectTask': 'Select a task',
      'currentTask': 'Current task',
      'newTask': 'New Task',
      'enterTaskTitle': 'Enter task title...',
      'addTask': 'Add Task',
      'eisenhowerMatrix': 'Eisenhower Matrix',
      'dragTasks': 'Drag tasks between categories',
      'urgentImportant': 'Urgent & Important',
      'notUrgentImportant': 'Not Urgent & Important',
      'urgentNotImportant': 'Urgent & Not Important',
      'notUrgentNotImportant': 'Not Urgent & Not Important',
      'today': 'Today',
      'currentStreak': 'Current streak',
      'days': 'days',
      'statistics': 'Statistics',
      'pomodorosCompleted': 'Pomodoros completed',
      'tasksFinished': 'Tasks finished',
      'totalFocusTime': 'Total focus time',
      'account': 'Account',
      'guest': 'Guest',
      'notLoggedIn': 'Not logged in',
      'language': 'Language',
      'theme': 'Theme',
      'darkMode': 'Dark Mode',
      'profileSettings': 'Profile Settings',
      'editProfile': 'Edit Profile',
      'logout': 'Logout',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'cancel': 'Cancel',
      'save': 'Save',
      'birthDate': 'Birth Date (YYYY-MM-DD)',
      'january': 'January',
      'february': 'February',
      'march': 'March',
      'april': 'April',
      'may': 'May',
      'june': 'June',
      'july': 'July',
      'august': 'August',
      'september': 'September',
      'october': 'October',
      'november': 'November',
      'december': 'December',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
    },
    'ru': {
      'appTitle': 'Помодоро Таймер',
      'timer': 'Таймер',
      'tasks': 'Задачи',
      'calendar': 'Календарь',
      'workTime': 'Рабочее время',
      'breakTime': 'Перерыв',
      'start': 'Старт',
      'pause': 'Пауза',
      'reset': 'Сброс',
      'selectTask': 'Выберите задачу',
      'currentTask': 'Текущая задача',
      'newTask': 'Новая задача',
      'enterTaskTitle': 'Введите название задачи...',
      'addTask': 'Добавить задачу',
      'eisenhowerMatrix': 'Матрица Эйзенхауэра',
      'dragTasks': 'Перетаскивайте задачи между категориями',
      'urgentImportant': 'Срочно & Важно',
      'notUrgentImportant': 'Не срочно & Важно',
      'urgentNotImportant': 'Срочно & Не важно',
      'notUrgentNotImportant': 'Не срочно & Не важно',
      'today': 'Сегодня',
      'currentStreak': 'Текущая серия',
      'days': 'дней',
      'statistics': 'Статистика',
      'pomodorosCompleted': 'Помодоров завершено',
      'tasksFinished': 'Задач выполнено',
      'totalFocusTime': 'Общее время фокуса',
      'account': 'Аккаунт',
      'guest': 'Гость',
      'notLoggedIn': 'Не авторизован',
      'language': 'Язык',
      'theme': 'Тема',
      'darkMode': 'Тёмная тема',
      'profileSettings': 'Настройки профиля',
      'editProfile': 'Редактировать профиль',
      'logout': 'Выйти',
      'login': 'Войти',
      'register': 'Зарегистрироваться',
      'email': 'Email',
      'password': 'Пароль',
      'username': 'Имя пользователя',
      'cancel': 'Отмена',
      'save': 'Сохранить',
      'birthDate': 'Дата рождения (ГГГГ-ММ-ДД)',
      'january': 'Январь',
      'february': 'Февраль',
      'march': 'Март',
      'april': 'Апрель',
      'may': 'Май',
      'june': 'Июнь',
      'july': 'Июль',
      'august': 'Август',
      'september': 'Сентябрь',
      'october': 'Октябрь',
      'november': 'Ноябрь',
      'december': 'Декабрь',
      'mon': 'Пн',
      'tue': 'Вт',
      'wed': 'Ср',
      'thu': 'Чт',
      'fri': 'Пт',
      'sat': 'Сб',
      'sun': 'Вс',
    },
  };

  final String languageCode;

  AppLocalizations(this.languageCode);

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? _localizedValues['en']![key]!;
  }

  String get appTitle => translate('appTitle');
  String get timer => translate('timer');
  String get tasks => translate('tasks');
  String get calendar => translate('calendar');
  String get workTime => translate('workTime');
  String get breakTime => translate('breakTime');
  String get start => translate('start');
  String get pause => translate('pause');
  String get reset => translate('reset');
  String get selectTask => translate('selectTask');
  String get currentTask => translate('currentTask');
  String get newTask => translate('newTask');
  String get enterTaskTitle => translate('enterTaskTitle');
  String get addTask => translate('addTask');
  String get eisenhowerMatrix => translate('eisenhowerMatrix');
  String get dragTasks => translate('dragTasks');
  String get urgentImportant => translate('urgentImportant');
  String get notUrgentImportant => translate('notUrgentImportant');
  String get urgentNotImportant => translate('urgentNotImportant');
  String get notUrgentNotImportant => translate('notUrgentNotImportant');
  String get today => translate('today');
  String get currentStreak => translate('currentStreak');
  String get days => translate('days');
  String get statistics => translate('statistics');
  String get pomodorosCompleted => translate('pomodorosCompleted');
  String get tasksFinished => translate('tasksFinished');
  String get totalFocusTime => translate('totalFocusTime');
  String get account => translate('account');
  String get guest => translate('guest');
  String get notLoggedIn => translate('notLoggedIn');
  String get language => translate('language');
  String get theme => translate('theme');
  String get darkMode => translate('darkMode');
  String get profileSettings => translate('profileSettings');
  String get editProfile => translate('editProfile');
  String get logout => translate('logout');
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get username => translate('username');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get birthDate => translate('birthDate');
  String getMonthName(int month) => translate([
    'january', 'february', 'march', 'april', 'may', 'june',
    'july', 'august', 'september', 'october', 'november', 'december'
  ][month - 1]);
  String get mon => translate('mon');
  String get tue => translate('tue');
  String get wed => translate('wed');
  String get thu => translate('thu');
  String get fri => translate('fri');
  String get sat => translate('sat');
  String get sun => translate('sun');
}