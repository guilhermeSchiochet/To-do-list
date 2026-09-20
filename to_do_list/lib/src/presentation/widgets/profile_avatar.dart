import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';

/// Avatar do usuário. Como a conta é local, não há foto para buscar: o
/// gradiente faz o papel dela e nada depende da rede.
/// The user's avatar. The account is local, so there is no photo to fetch.
class ProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({super.key, this.size = 32, this.onTap});

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppPalette.primary, AppPalette.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );

    if (onTap == null) return avatar;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: avatar,
    );
  }
}
