import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? avatarImageUrl;

  const MyAppBar({Key? key, this.avatarImageUrl}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2.1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSearchTextField(),
            const SizedBox(width: 10),
            _buildNotificationIcon(),
            const SizedBox(width: 10),
            _buildAvatar(context),
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
          filled: true,
          hintText: 'Search taks...',
          fillColor: Colors.grey.shade100,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24
          ),
        ),
      ),
    );
  }

  /// Cria um ícone de notificação.
  Widget _buildNotificationIcon() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.notifications_none_rounded,
        size: 33,
      )
    );
  }

/// Cria um widget de avatar com uma imagem de perfil ou um ícone padrão.
  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.symmetric(vertical: 80.0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _circleAvatar,
                  const SizedBox(height: 20),
                  const Text('Stark'),
                  const SizedBox(height: 30),
                  _elevatedButton('Configurações', height: 30, width: 180),
                  const SizedBox(height: 20),
                  _elevatedButton('Notificações', height: 30, width: 180),
                  const SizedBox(height: 20),
                  _elevatedButton('Como utilizar o app', height: 30, width: 180),
                ],
              ),
            );
          },
        );
      },
      child: _circleAvatar
    );
  }

  Widget get _circleAvatar {
    return CircleAvatar(
      radius: 27,
      backgroundColor: Colors.grey.shade100,
      backgroundImage: avatarImageUrl != null ? NetworkImage(avatarImageUrl!) : null,
      child: avatarImageUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
    );
  }

  Widget _elevatedButton(String name, {required double width, required double height}) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(8.0),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0
          )
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
