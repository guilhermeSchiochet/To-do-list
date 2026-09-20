import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:to_do_list/src/data/services/notification_service.dart';

/// O que a tela de preferências precisa saber sobre o app.
/// What the settings screen needs to know about the app.
@immutable
class SettingsState {
  /// Versão do app, nula enquanto ainda está sendo lida.
  final String? version;

  /// Se o sistema já autorizou as notificações.
  final bool remindersEnabled;

  const SettingsState({this.version, this.remindersEnabled = false});

  SettingsState copyWith({String? version, bool? remindersEnabled}) {
    return SettingsState(
      version: version ?? this.version,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }
}

/// Carrega os dados da tela de preferências e fala com o sistema.
/// Loads the settings screen data and talks to the system.
class SettingsController {
  final NotificationService _notifications;

  SettingsController({NotificationService? notificationService})
      : _notifications = notificationService ?? NotificationService.instance;

  late final ValueNotifier<SettingsState> _state = ValueNotifier<SettingsState>(
    SettingsState(remindersEnabled: _notifications.hasPermission),
  );

  ValueListenable<SettingsState> get state => _state;

  /// Se vale mostrar a seção de notificações nesta plataforma.
  bool get supportsReminders => _notifications.isSupported;

  /// Lê a versão do app a partir do pacote instalado, em vez de repetir o
  /// número no código e deixá-lo envelhecer.
  Future<void> load() async {
    final info = await PackageInfo.fromPlatform();
    _state.value = _state.value.copyWith(version: info.version);
  }

  /// Pede a permissão ao sistema. Só o sistema pode concedê-la, então o
  /// estado reflete a resposta dele, não o toque do usuário.
  Future<void> requestReminders() async {
    final granted = await _notifications.requestPermission();
    _state.value = _state.value.copyWith(remindersEnabled: granted);
  }

  void dispose() => _state.dispose();
}
