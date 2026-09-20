import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';

/// Barra de topo das telas empilhadas, com o título centrado e o botão de
/// voltar no estilo iOS.
/// Top bar of pushed screens, with a centered title and an iOS-style back
/// button.
class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ScreenAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: AppPalette.primary,
      ),
    );
  }
}
