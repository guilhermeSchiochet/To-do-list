import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';
import 'package:to_do_list/src/presentation/controller/settings_controller.dart';
import 'package:to_do_list/src/presentation/controller/theme_controller.dart';
import 'package:to_do_list/src/presentation/widgets/grouped_section.dart';
import 'package:to_do_list/src/presentation/widgets/large_title_header.dart';
import 'package:to_do_list/src/presentation/widgets/my_button_bar.dart';
import 'package:to_do_list/src/presentation/widgets/profile_avatar.dart';
import 'package:to_do_list/src/utils/constants/app_strings.dart';

/// Preferências do app.
/// App preferences.
class SettingsView extends StatefulWidget {
  final ThemeController themeController;

  const SettingsView({super.key, required this.themeController});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController _controller = SettingsController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: LargeTitleHeader(title: strings.settingsTitle),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MyBottomBar.contentInset,
          ),
          sliver: SliverList.list(
            children: [
              const _ProfileCard(),
              const SizedBox(height: 26),
              _appearanceSection(),
              if (_controller.supportsReminders) ...[
                const SizedBox(height: 26),
                _notificationsSection(),
              ],
              const SizedBox(height: 26),
              _aboutSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appearanceSection() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeController.mode,
      builder: (context, mode, _) {
        final followsSystem = mode == ThemeMode.system;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return GroupedSection(
          title: strings.settingsAppearance,
          children: [
            GroupedRow(
              icon: Icons.phone_iphone_rounded,
              iconColor: AppPalette.gray,
              title: strings.settingsUseSystemTheme,
              trailing: CupertinoSwitch(
                value: followsSystem,
                activeTrackColor: AppPalette.green,
                onChanged: (value) => widget.themeController.setMode(
                  value
                      ? ThemeMode.system
                      : (isDark ? ThemeMode.dark : ThemeMode.light),
                ),
              ),
            ),
            GroupedRow(
              icon: Icons.dark_mode_rounded,
              iconColor: AppPalette.indigo,
              title: strings.settingsDarkMode,
              trailing: CupertinoSwitch(
                value: isDark,
                // Seguindo o sistema, o tema não é escolhido aqui.
                onChanged: followsSystem
                    ? null
                    : (value) => widget.themeController
                        .setMode(value ? ThemeMode.dark : ThemeMode.light),
                activeTrackColor: AppPalette.green,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _notificationsSection() {
    return ValueListenableBuilder<SettingsState>(
      valueListenable: _controller.state,
      builder: (context, state, _) => GroupedSection(
        title: strings.settingsNotifications,
        children: [
          GroupedRow(
            icon: Icons.notifications_rounded,
            iconColor: AppPalette.primary,
            title: strings.fieldRemindMe,
            trailing: CupertinoSwitch(
              value: state.remindersEnabled,
              activeTrackColor: AppPalette.green,
              onChanged: (enabled) {
                if (enabled) _controller.requestReminders();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutSection() {
    return ValueListenableBuilder<SettingsState>(
      valueListenable: _controller.state,
      builder: (context, state, _) => GroupedSection(
        title: strings.settingsAbout,
        children: [
          GroupedRow(
            icon: Icons.info_rounded,
            iconColor: AppPalette.gray,
            title: strings.settingsVersion,
            trailing: GroupedValue(state.version ?? '—'),
          ),
          GroupedRow(
            icon: Icons.code_rounded,
            iconColor: AppPalette.primary,
            title: strings.settingsDeveloper,
            trailing: GroupedValue(strings.settingsDeveloperName),
          ),
        ],
      ),
    );
  }
}

/// Cartão de perfil do topo da tela.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const ProfileAvatar(size: 52),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.settingsProfileName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.label,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                strings.settingsProfileSubtitle,
                style: TextStyle(fontSize: 14, color: colors.secondaryLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
