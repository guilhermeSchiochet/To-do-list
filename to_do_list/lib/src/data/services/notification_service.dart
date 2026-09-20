import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/src/domain/model/task_model.dart';

/// Agenda e cancela os lembretes locais das tarefas.
/// Schedules and cancels the tasks' local reminders.
///
/// Todas as operações são silenciosamente ignoradas em plataformas sem
/// suporte, para que a UI nunca precise checar em qual sistema está rodando.
class NotificationService {
  NotificationService();

  /// Instância compartilhada pelo app. O estado de inicialização e de
  /// permissão precisa ser único; os testes criam a própria instância.
  /// Shared app-wide instance; tests create their own.
  static final NotificationService instance = NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// GUID fixo do app, exigido pelo Windows para identificar as notificações.
  static const String _windowsGuid = '3f9d2a54-7e18-4c6b-9a0f-2c5b8d1e4f07';

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    'task_reminders',
    'Task reminders',
    channelDescription: 'Reminders for tasks with a due date',
    importance: Importance.high,
    priority: Priority.high,
  );

  bool _initialized = false;
  bool _permissionGranted = false;

  /// Se o sistema atual consegue exibir notificações locais.
  bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isWindows);

  /// Se o usuário concedeu permissão para notificar.
  bool get hasPermission => _permissionGranted;

  /// Prepara o plugin e o banco de fusos horários. Seguro de chamar mais de
  /// uma vez.
  Future<void> initialize() async {
    if (_initialized || !isSupported) return;

    tz_data.initializeTimeZones();
    await _useDeviceTimeZone();

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
        windows: WindowsInitializationSettings(
          appName: 'ToDoList',
          appUserModelId: 'com.guilherme.ToDoList',
          guid: _windowsGuid,
        ),
      ),
    );

    _initialized = true;
    _permissionGranted = await _resolveInitialPermission();
  }

  /// Pede permissão ao usuário. Retorna se ela foi concedida.
  /// Asks the user for permission. Returns whether it was granted.
  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    await initialize();

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      _permissionGranted = await android?.requestNotificationsPermission() ?? false;
    } else if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      _permissionGranted =
          await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
              false;
    } else {
      // O Windows não tem um fluxo de permissão em tempo de execução.
      _permissionGranted = true;
    }

    return _permissionGranted;
  }

  /// Reagenda o lembrete da tarefa, refletindo o estado atual dela.
  ///
  /// Cancela qualquer lembrete anterior e só agenda de novo quando a tarefa
  /// pede lembrete, está pendente e vence no futuro.
  Future<void> syncReminder(TaskModel task) async {
    if (!isSupported) return;
    await initialize();
    await cancelReminder(task);

    if (!task.hasReminder || task.isCompleted) return;

    final dueAt = task.dueAt;
    if (dueAt == null || !dueAt.isAfter(DateTime.now())) return;
    if (!_permissionGranted && !await requestPermission()) return;

    try {
      await _plugin.zonedSchedule(
        id: _idFor(task),
        title: task.title,
        body: task.description?.trim().isNotEmpty == true
            ? task.description
            : task.category.label,
        scheduledDate: tz.TZDateTime.from(dueAt, tz.local),
        notificationDetails: const NotificationDetails(
          android: _androidDetails,
          iOS: DarwinNotificationDetails(),
          windows: WindowsNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: task.id,
      );
    } on Exception catch (error) {
      // Um lembrete que falha não pode derrubar o salvamento da tarefa.
      debugPrint('Falha ao agendar lembrete de "${task.title}": $error');
    }
  }

  /// Remove o lembrete pendente da tarefa, se houver.
  Future<void> cancelReminder(TaskModel task) async {
    if (!isSupported || !_initialized) return;

    try {
      await _plugin.cancel(id: _idFor(task));
    } on Exception catch (error) {
      debugPrint('Falha ao cancelar lembrete de "${task.title}": $error');
    }
  }

  /// Aponta o pacote `timezone` para o fuso do aparelho, para que o horário
  /// escolhido pelo usuário seja o horário em que a notificação dispara.
  Future<void> _useDeviceTimeZone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } on Exception catch (error) {
      // Sem o fuso do aparelho o agendamento cai no UTC, o que é melhor do
      // que impedir a inicialização do serviço.
      debugPrint('Não foi possível detectar o fuso horário local: $error');
    }
  }

  Future<bool> _resolveInitialPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.areNotificationsEnabled() ?? false;
    }
    // iOS só informa o estado ao pedir; o Windows não exige permissão.
    return Platform.isWindows;
  }

  /// O plugin identifica notificações por um int de 32 bits, mas o id da
  /// tarefa é textual. O hash mantém a associação estável entre execuções.
  int _idFor(TaskModel task) => task.id.hashCode & 0x7FFFFFFF;
}
