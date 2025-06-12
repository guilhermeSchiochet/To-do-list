import 'package:flutter/material.dart';
import 'package:to_do_list/src/utils/extensions/colors_extension.dart';

class CardProjects extends StatelessWidget {

  final String title;
  final String subtitle;
  final Color color;
  final int progress;
  final int totalTasks;
  final IconData icon;

  const CardProjects({super.key, required this.title, required this.subtitle, required this.color, required this.icon, required this.progress, required this.totalTasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withAlphaPercent(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBaseIcon(),
                Icon(Icons.more_horiz, color: const Color.fromARGB(255, 65, 63, 63)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
             title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color.fromARGB(255, 65, 63, 63),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$progress/$totalTasks Tasks',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 10,
                backgroundColor: Colors.grey.shade300,
                color: color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaseIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withAlphaPercent(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.emoji_objects_outlined,
        color: color,
        size: 24,
      ),
    );  
  } 

}
