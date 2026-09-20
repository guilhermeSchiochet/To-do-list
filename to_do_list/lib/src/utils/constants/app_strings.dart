/// Todos os textos exibidos na UI ficam aqui, nunca soltos nos widgets.
/// Every string shown in the UI lives here, never inline in the widgets.
///
/// Para adicionar um idioma, crie uma classe que implemente [AppStrings]
/// (ex.: `AppStringsPt`) e atribua a instância a [strings] na inicialização.
/// Nenhuma tela precisa ser alterada.
abstract interface class AppStrings {
  // App
  String get appTitle;

  // Navegação / Navigation
  String get navToday;
  String get navCalendar;
  String get navLists;
  String get navSettings;

  // Today
  String get todayTitle;
  String get completedSection;
  String get emptyTodayTitle;
  String get emptyTodaySubtitle;

  /// Ex.: "of 12 tasks completed".
  String tasksCompleted(int total);

  // Calendar
  String get calendarMonth;
  String get calendarWeek;
  String get emptyDayTitle;
  String get emptyDaySubtitle;

  // Lists
  String get listsTitle;
  String get listsEdit;
  String get listsDone;
  String get listsMyLists;
  String get smartListToday;
  String get smartListScheduled;
  String get smartListAll;
  String get smartListFlagged;

  // Search
  String get searchTitle;
  String get searchHint;
  String get searchEmptyTitle;
  String get searchEmptySubtitle;

  /// Ex.: "No results for “meeting”".
  String searchNoResults(String query);

  // Task editor
  String get newTaskTitle;
  String get editTaskTitle;
  String get cancel;
  String get add;
  String get save;
  String get delete;
  String get fieldTitleHint;
  String get fieldNotesHint;
  String get sectionDetails;
  String get sectionOptions;
  String get fieldPriority;
  String get fieldDueDate;
  String get fieldTime;
  String get fieldList;
  String get fieldFlag;
  String get fieldRemindMe;
  String get fieldLocation;
  String get selectDate;
  String get selectTime;
  String get none;
  String get locationDialogTitle;
  String get locationDialogHint;

  // Prioridades / Priorities
  String get priorityLow;
  String get priorityMedium;
  String get priorityHigh;

  // Categorias / Categories
  String get categoryWork;
  String get categoryPersonal;
  String get categoryShopping;
  String get categoryHealth;
  String get categoryTravel;

  // Settings
  String get settingsTitle;
  String get settingsProfileName;
  String get settingsProfileSubtitle;
  String get settingsAppearance;
  String get settingsDarkMode;
  String get settingsUseSystemTheme;
  String get settingsNotifications;
  String get settingsAbout;
  String get settingsVersion;
  String get settingsDeveloper;
  String get settingsDeveloperName;

  // Feedback
  String get taskDeleted;
  String get undo;
  String get reminderPermissionDenied;
}

/// Textos em inglês, o idioma padrão do app.
/// English strings, the app's default language.
final class AppStringsEn implements AppStrings {
  const AppStringsEn();

  @override
  String get appTitle => 'To Do List';

  @override
  String get navToday => 'Today';
  @override
  String get navCalendar => 'Calendar';
  @override
  String get navLists => 'Lists';
  @override
  String get navSettings => 'Settings';

  @override
  String get todayTitle => 'Today';
  @override
  String get completedSection => 'COMPLETED';
  @override
  String get emptyTodayTitle => 'Nothing due today';
  @override
  String get emptyTodaySubtitle => 'Tap + to plan your day.';
  @override
  String tasksCompleted(int total) =>
      'of $total ${total == 1 ? 'task' : 'tasks'} completed';

  @override
  String get calendarMonth => 'Month';
  @override
  String get calendarWeek => 'Week';
  @override
  String get emptyDayTitle => 'All clear';
  @override
  String get emptyDaySubtitle => 'No tasks scheduled.';

  @override
  String get listsTitle => 'Lists';
  @override
  String get listsEdit => 'Edit';
  @override
  String get listsDone => 'Done';
  @override
  String get listsMyLists => 'My Lists';
  @override
  String get smartListToday => 'Today';
  @override
  String get smartListScheduled => 'Scheduled';
  @override
  String get smartListAll => 'All';
  @override
  String get smartListFlagged => 'Flagged';

  @override
  String get searchTitle => 'Search';
  @override
  String get searchHint => 'Search tasks';
  @override
  String get searchEmptyTitle => 'Search your tasks';
  @override
  String get searchEmptySubtitle => 'Find by title, notes or list.';
  @override
  String searchNoResults(String query) => 'No results for “$query”';

  @override
  String get newTaskTitle => 'New Task';
  @override
  String get editTaskTitle => 'Edit Task';
  @override
  String get cancel => 'Cancel';
  @override
  String get add => 'Add';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get fieldTitleHint => 'Title';
  @override
  String get fieldNotesHint => 'Notes';
  @override
  String get sectionDetails => 'DETAILS';
  @override
  String get sectionOptions => 'OPTIONS';
  @override
  String get fieldPriority => 'Priority';
  @override
  String get fieldDueDate => 'Due Date';
  @override
  String get fieldTime => 'Time';
  @override
  String get fieldList => 'List';
  @override
  String get fieldFlag => 'Flag';
  @override
  String get fieldRemindMe => 'Remind Me';
  @override
  String get fieldLocation => 'Location';
  @override
  String get selectDate => 'Select Date';
  @override
  String get selectTime => 'Select Time';
  @override
  String get none => 'None';
  @override
  String get locationDialogTitle => 'Location';
  @override
  String get locationDialogHint => 'Where does this happen?';

  @override
  String get priorityLow => 'Low';
  @override
  String get priorityMedium => 'Medium';
  @override
  String get priorityHigh => 'High';

  @override
  String get categoryWork => 'Work';
  @override
  String get categoryPersonal => 'Personal';
  @override
  String get categoryShopping => 'Shopping';
  @override
  String get categoryHealth => 'Health';
  @override
  String get categoryTravel => 'Travel';

  @override
  String get settingsTitle => 'Settings';
  @override
  String get settingsProfileName => 'User Profile';
  @override
  String get settingsProfileSubtitle => 'Local User Account';
  @override
  String get settingsAppearance => 'APPEARANCE';
  @override
  String get settingsDarkMode => 'Dark Mode';
  @override
  String get settingsUseSystemTheme => 'Match System';
  @override
  String get settingsNotifications => 'NOTIFICATIONS';
  @override
  String get settingsAbout => 'ABOUT';
  @override
  String get settingsVersion => 'App Version';
  @override
  String get settingsDeveloper => 'Developer';
  @override
  String get settingsDeveloperName => 'Guilherme Schiochet';

  @override
  String get taskDeleted => 'Task deleted';
  @override
  String get undo => 'Undo';
  @override
  String get reminderPermissionDenied =>
      'Enable notifications in system settings to get reminders.';
}

/// Instância ativa. Troque aqui para mudar o idioma de todo o app.
/// Active instance. Swap this to change the whole app's language.
const AppStrings strings = AppStringsEn();
