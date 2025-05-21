import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showDrawerIcon;

  const SharedAppBar({
    Key? key,
    this.title = 'Tindahan Ni Aling Nena',
    this.actions,
    this.showDrawerIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                // Show notifications
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                // Show shopping cart
              },
            ),
          ],
      iconTheme: const IconThemeData(color: Colors.white),
      // Only show the drawer icon if showDrawerIcon is true
      automaticallyImplyLeading: showDrawerIcon,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
