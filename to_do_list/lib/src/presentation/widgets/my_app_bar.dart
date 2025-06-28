import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? avatarImageUrl;

  const MyAppBar({super.key, this.avatarImageUrl});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2.4);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = preferredSize.height;

    return Container(
      height: preferredSize.height,
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Row(
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.tituloPreto,
                    ),
                  ),
                  const Spacer(),
                  _buildIconSearch(),
                  const SizedBox(width: 10),
                  _buildIconNotification(),
                ],
              ),
            ),
            Positioned(
              left: 8,
              top: screenHeight * 0.45,
              child: Text(
                '2 tasks pending',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.cinzaEscuro,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconNotification() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            LucideIcons.bell,
            size: 30,
            color: AppTheme.cinzaEscuro,
          ),
          onPressed: () {},
        ),
        Positioned(
          top: 14,
          right: 14,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconSearch () {
    return IconButton(
      icon: const Icon(
        LucideIcons.search,
        size: 30,
        color: AppTheme.cinzaEscuro,
      ),
      onPressed: () {},
    );
  }
}