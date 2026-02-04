import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';
import 'package:intl/intl.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dataFormatada,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.cinzaUmPoucoMenosEscuro,
              ),
            ),
            Center(
              child: Row(
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
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
            size: 22,
            color: AppTheme.cinzaEscuro,
          ),
          onPressed: () {},
        ),
        Positioned(
          top: 6,
          right: 12,
          child: Container(
            width: 4,
            height: 4,
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
        size: 22,
        color: AppTheme.primaryColor,
      ),
      onPressed: () {},
    );
  }

  static String get dataFormatada {
    DateTime agora = DateTime.now();

    String formato = DateFormat('EEEE, MMM d', 'en_US').format(agora);
    
    return formato.toUpperCase();
  }

}