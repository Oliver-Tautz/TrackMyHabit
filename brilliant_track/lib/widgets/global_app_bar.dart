import 'package:flutter/material.dart';
import '../main.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final bool showHomeButton;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showHomeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showHomeButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: 'Home',
                child: IconButton(
                  icon: Image.asset(
                    'assets/top_icon.png',
                    width: 36,
                    height: 36,
                  ),
                  onPressed: () {
                    navigatorKey.currentState?.popUntil((r) => r.isFirst);
                  },
                ),
              ),
            )
          : null,
      title: title,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
