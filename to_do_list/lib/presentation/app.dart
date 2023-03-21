import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/screens/home_page.dart';
import 'package:to_do_list/presentation/widgets/theme_app.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeApp.themeApp,
    );
  }
}
