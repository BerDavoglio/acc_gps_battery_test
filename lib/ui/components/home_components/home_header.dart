import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 80,
      toolbarHeight: 100,
      centerTitle: true,
      title: const Text(
        'Denso',
        style: TextStyle(
          fontSize: 40,
        ),
      ),
    );
  }
}
