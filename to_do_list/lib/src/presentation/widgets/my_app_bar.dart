import 'dart:io';
import 'package:lottie/lottie.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            _circleAvatar(
              context,
              size: 27,
              onTapDown: (TapDownDetails details) {
                _showPopupMenu(details.globalPosition, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(Offset offset, context) async {

    await showMenu(
      context: context,
      color: Colors.white,
      position: const RelativeRect.fromLTRB(110, 50, 90, 20),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
            enabled: false,
            value: 'Desenvolvedor',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _circleAvatar(
                  context,
                  size: 70,
                  onTapDown: (c) {
                    _showModalBottomSheet(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: const Text(
                    'Configurações',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {},
                ),
                Divider(
                    height: 0.5, thickness: 0.5, color: Colors.grey.shade800),
                ListTile(
                  title: const Text(
                    'Desenvolvedor',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {},
                ),
              ],
            )),
      ],
      elevation: 8.0,
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Selecionar imagem',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Lottie.asset(
                          'assets/json/gallery_animated.json',
                          width: 120,
                          height: 120,
                          repeat: false,
                        ),
                        const Text(
                          'Galeria',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Lottie.asset(
                          'assets/json/camera_animated.json',
                          width: 140,
                          height: 120,
                          repeat: false,
                        ),
                        const Text(
                          'Câmera',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _saveImagePath(pickedFile.path);
    }
  }

  Future<void> _saveImagePath(String imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('avatar_image_path', imagePath);
    } catch (e) {
      throw 'Erro ao salvar o caminho da imagem: $e';
    }
  }

  Future<String?> _getImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('avatar_image_path');
  }

  Widget _circleAvatar(context, {required double size, void Function(TapDownDetails)? onTapDown}) {
    return FutureBuilder(
      future: _getImagePath(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        return GestureDetector(
          onTapDown: onTapDown,
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: snapshot.data != null ? FileImage(File(snapshot.data!)) : null,
            child: snapshot.data == null ? const CircularProgressIndicator() : null,
          )
        );
      },
    );
  }
}
