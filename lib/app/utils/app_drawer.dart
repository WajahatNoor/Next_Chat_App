import 'package:flutter/material.dart';
import 'package:next_chat/app/utils/app_dialougs.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Column(
            children: [
              Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  AppDialogs.showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
