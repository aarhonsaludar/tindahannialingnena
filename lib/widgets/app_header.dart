import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppHeader({Key? key, required this.title, this.actions})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      // This will automatically show the drawer icon if there's a Drawer in the Scaffold
      // No need for explicit leading widget
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
