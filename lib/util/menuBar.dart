
import 'package:flutter/material.dart';
import 'package:gymfront/main.dart';
import 'package:gymfront/util/logout.dart';

enum MenuAction { logout }

class MenuActionsWidget extends StatelessWidget {
  final BuildContext context;

  const MenuActionsWidget({required this.context});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showlogoutDialogf(context);
            if (shouldLogout) {
              await logout(context);
            }
            break;
        }
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text("Logout"),
          ),
        ];
      },
    );
  }
}