import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';

class DefaultContainer extends StatelessWidget {
  final List<Widget> children;
  final bool activeDivider;

  const DefaultContainer({super.key, required this.children, this.activeDivider = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.cinzaClaro,
          width: 0.3,
        ),
      ),
      child: Column(
        children: children.expand((widget) sync* {
          yield widget;
          if (activeDivider && widget != children.last) {
            yield Divider(
              color: AppTheme.cinzaClaro,
              height: 0.5,
              thickness: 0.3,
            );
          }
        }).toList(),  
      )
    );
  }
}