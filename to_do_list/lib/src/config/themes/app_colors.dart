import 'package:flutter/material.dart';

/// Paleta de cores do app, espelhando o sistema de cores do iOS.
/// App color palette, mirroring the iOS system colors.
///
/// Toda cor usada na UI deve sair daqui. Para consumir a variante correta do
/// tema atual, prefira `Theme.of(context).extension<AppColors>()!` através do
/// atalho [AppColorsX.colors] em `BuildContext`.
abstract final class AppPalette {
  /// Azul de destaque (iOS systemBlue).
  static const Color primary = Color(0xFF007AFF);

  /// Verde de confirmação (iOS systemGreen), usado nos switches.
  static const Color green = Color(0xFF34C759);

  /// Vermelho destrutivo (iOS systemRed), usado em exclusões e prioridade alta.
  static const Color red = Color(0xFFFF3B30);

  /// Amarelo de atenção (iOS systemYellow), usado na prioridade média.
  static const Color yellow = Color(0xFFFFCC00);

  /// Índigo (iOS systemIndigo), usado na prioridade baixa.
  static const Color indigo = Color(0xFF5856D6);

  /// Laranja (iOS systemOrange), usado no marcador de tarefas sinalizadas.
  static const Color orange = Color(0xFFFF9500);

  /// Cinza neutro para textos secundários, idêntico nos dois temas.
  static const Color gray = Color(0xFF8E8E93);
}

/// Cores que mudam entre os temas claro e escuro.
/// Colors that change between the light and dark themes.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Fundo da tela.
  final Color background;

  /// Fundo dos cards e listas agrupadas.
  final Color surface;

  /// Fundo de controles secundários (segmented control, chips).
  final Color fill;

  /// Fundo do item selecionado dentro de um controle segmentado.
  final Color selectedFill;

  /// Linha divisória entre itens de lista.
  final Color separator;

  /// Texto principal.
  final Color label;

  /// Texto secundário.
  final Color secondaryLabel;

  /// Texto desabilitado, como dias fora do mês no calendário.
  final Color tertiaryLabel;

  const AppColors({
    required this.background,
    required this.surface,
    required this.fill,
    required this.selectedFill,
    required this.separator,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
  });

  static const AppColors light = AppColors(
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    fill: Color(0xFFE5E5EA),
    selectedFill: Color(0xFFFFFFFF),
    separator: Color(0x14000000),
    label: Color(0xFF000000),
    secondaryLabel: AppPalette.gray,
    tertiaryLabel: Color(0xFFC6C6C8),
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    fill: Color(0xFF2C2C2E),
    selectedFill: Color(0xFF636366),
    separator: Color(0x1AFFFFFF),
    label: Color(0xFFFFFFFF),
    secondaryLabel: AppPalette.gray,
    tertiaryLabel: Color(0xFF3A3A3C),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? fill,
    Color? selectedFill,
    Color? separator,
    Color? label,
    Color? secondaryLabel,
    Color? tertiaryLabel,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      fill: fill ?? this.fill,
      selectedFill: selectedFill ?? this.selectedFill,
      separator: separator ?? this.separator,
      label: label ?? this.label,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      tertiaryLabel: tertiaryLabel ?? this.tertiaryLabel,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      fill: Color.lerp(fill, other.fill, t)!,
      selectedFill: Color.lerp(selectedFill, other.selectedFill, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      label: Color.lerp(label, other.label, t)!,
      secondaryLabel: Color.lerp(secondaryLabel, other.secondaryLabel, t)!,
      tertiaryLabel: Color.lerp(tertiaryLabel, other.tertiaryLabel, t)!,
    );
  }
}

/// Atalho para ler as cores do tema sem repetir a busca pela extensão.
/// Shortcut to read the theme colors without repeating the extension lookup.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
