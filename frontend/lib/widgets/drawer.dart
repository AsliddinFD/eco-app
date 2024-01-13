import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widgets/switcher.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(email),
            accountName: Text(user_name),
            currentAccountPicture: const CircleAvatar(
              child: Icon(CupertinoIcons.profile_circled),
            ),
          ),
          const SizedBox(height: 15),
          const ListTile(
            title: Row(
              children: [
                Text('Theme Mode'),
                Spacer(),
                Icon(CupertinoIcons.sun_max),
                Switcher(),
                Icon(CupertinoIcons.moon),
              ],
            ),
          ),
          ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
