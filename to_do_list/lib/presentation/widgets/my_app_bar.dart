import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? avatarImageUrl;

  const MyAppBar({Key? key, this.avatarImageUrl}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSearchTextField(),
            const SizedBox(width: 16),
            _buildNotificationIcon(),
            const SizedBox(width: 16),
            _buildAvatar(),
          ],
        ),
      ),
    );
  }

  /// Cria um campo de pesquisa estilizado semelhante ao da Play Store.
  Widget _buildSearchTextField() {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
    );
  }

  /// Cria um ícone de notificação.
  Widget _buildNotificationIcon() {
    return const Icon(Icons.notifications, size: 28);
  }

  /// Cria um widget de avatar com uma imagem de perfil ou um ícone padrão.
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        backgroundImage: avatarImageUrl != null ? NetworkImage(avatarImageUrl!) : null,// Se avatarImageUrl for nulo, o CircleAvatar mostrará o ícone padrão definido abaixo
        radius: 24, 
        child: avatarImageUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
      ),
    );
  }
}
