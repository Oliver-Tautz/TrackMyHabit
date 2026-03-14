import 'package:flutter/material.dart';
import '../main.dart';
// no direct dependency on HomeScreen; navigatorKey is used for navigation

/// Reusable global app bar used across the app. Shows the app icon on the
/// left, a provided title widget and optional actions on the right.
class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const GlobalAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // If not on home, navigate back to root (home screen)
                try {
                  navigatorKey.currentState?.popUntil((r) => r.isFirst);
                } catch (_) {}
              },
              child: Tooltip(
                message: 'Home',
                child: Image.asset(
                  'assets/top_icon.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
      title: title,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
