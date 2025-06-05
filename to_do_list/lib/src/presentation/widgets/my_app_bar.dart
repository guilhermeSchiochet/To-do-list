import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 65, 63, 63),
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
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade500,
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
            Icons.notifications_none_outlined,
            size: 30,
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
        Icons.search,
        size: 30,
      ),
      onPressed: () {},
    );
  }
  
  // void _showPopupMenu(Offset offset, context) async {

  //   await showMenu(
  //     context: context,
  //     color: Colors.white,
  //     position: const RelativeRect.fromLTRB(110, 50, 90, 20),
  //     items: <PopupMenuEntry<String>>[
  //       PopupMenuItem<String>(
  //           enabled: false,
  //           value: 'Desenvolvedor',
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               _circleAvatar(
  //                 size: 70,
  //                 onTapDown: (c) {
  //                   _showModalBottomSheet(context);
  //                 },
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               ListTile(
  //                 title: const Text(
  //                   'Configurações',
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onTap: () {},
  //               ),
  //               Divider(
  //                   height: 0.5, thickness: 0.5, color: Colors.grey.shade800),
  //               ListTile(
  //                 title: const Text(
  //                   'Desenvolvedor',
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onTap: () {},
  //               ),
  //             ],
  //           )),
  //     ],
  //     elevation: 8.0,
  //   );
  // }

  // void _showModalBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.only(top: 15, bottom: 40),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(20.0),
  //               child: Text(
  //                 'Selecionar imagem',
  //                 textAlign: TextAlign.right,
  //                 style: TextStyle(
  //                   fontSize: 21,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.grey.shade800
  //                 ),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     _pickImage(ImageSource.gallery);
  //                   },
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Lottie.asset(
  //                         'assets/json/gallery_animated.json',
  //                         width: 120,
  //                         height: 120,
  //                         repeat: false,
  //                       ),
  //                       const Text(
  //                         'Galeria',
  //                         style: TextStyle(
  //                           fontSize: 17, fontWeight: FontWeight.w500
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     _pickImage(ImageSource.camera);
  //                   },
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Lottie.asset(
  //                         'assets/json/camera_animated.json',
  //                         width: 140,
  //                         height: 120,
  //                         repeat: false,
  //                       ),
  //                       const Text(
  //                         'Câmera',
  //                         style: TextStyle(
  //                           fontSize: 17,
  //                           fontWeight: FontWeight.w500
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> _pickImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     _saveImagePath(pickedFile.path);
  //   }
  // }

  // Future<void> _saveImagePath(String imagePath) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('avatar_image_path', imagePath);
  //   } catch (e) {
  //     throw 'Erro ao salvar o caminho da imagem: $e';
  //   }
  // }

  // Future<String?> _getImagePath() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('avatar_image_path');
  // }

  // Widget _circleAvatar({required double size, void Function(TapDownDetails)? onTapDown}) {
  //   return FutureBuilder(
  //     future: _getImagePath(),
  //     builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
  //       return GestureDetector(
  //         onTapDown: onTapDown,
  //         child: CircleAvatar(
  //           radius: size,
  //           backgroundColor: Colors.grey.shade100,
  //           backgroundImage: snapshot.data != null ? FileImage(File(snapshot.data!)) : null,
  //           child: snapshot.data == null ? const CircularProgressIndicator() : null,
  //         )
  //       );
  //     },
  //   );
  // }
}
