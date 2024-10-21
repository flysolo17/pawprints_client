import 'package:flutter/material.dart';

class PawprintsAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const PawprintsAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white),
      backgroundColor: const Color(0xFF001B44),
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
