

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/auth/service.dart';
import 'package:gymfront/views/list_coach_users_view.dart';
import 'package:gymfront/views/login_view.dart';
import 'package:gymfront/views/register_view.dart';
import 'dart:developer' show log;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final authenticationService = AuthenticationService();
  final isLoggedIn = await authenticationService.isLoggedIn();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomePage() : const  LoginView(),
      routes: {
        "/login": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
        "/home": (context) => const HomePage(),
        "/coach_users":(context) => const ListCoachUsers()
      },
    ));
}

enum MenuAction { logout }
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(context) async {
  try {
    final _storage = const FlutterSecureStorage();
    await _storage.deleteAll();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);

  } catch (error) {
    // Handle any errors that may occur during logout
    log(error.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch(value){
              
              case MenuAction.logout:
                final shouldLogout = await showlogoutDialogf(context);
                print(shouldLogout);
                if (shouldLogout){
                  await _logout(context);
                }
                break;
            }
          },
          itemBuilder: (context) {
            return const [
             PopupMenuItem<MenuAction>(value:MenuAction.logout , child: Text("Logout")),
            ];
          },
          )
        ],
        ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Your Users'),
              onTap: () {
                // Navigate to Location 1
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/coach_users');
              },
            ),
            // Add more ListTiles for other locations
          ],
        ),
      ),
      body: const Column(
        children: [
          Text("pass"),
        ],
      ),
    );
  }
}

Future<bool> showlogoutDialogf (BuildContext context) {
  return showDialog<bool>(
    context: context,
     builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are sure you want sign out"),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancel")),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);

          },
          child: const Text("Logout"))
        ],
      );
     }
     ).then((value) => value ?? false);
}