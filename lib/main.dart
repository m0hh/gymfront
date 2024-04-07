

import 'package:flutter/material.dart';
import 'package:gymfront/auth/service.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/util/menuBar.dart';
import 'package:gymfront/views/add_update_food.dart';
import 'package:gymfront/views/am_snack_view.dart';
import 'package:gymfront/views/list_coach_users_view.dart';
import 'package:gymfront/views/list_foods.dart';
import 'package:gymfront/views/login_view.dart';
import 'package:gymfront/views/meals_view.dart';
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
      home: const MealsView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomePage(),
        coachUsersRoute:(context) => const ListCoachUsers(),
        addUpdateFoodRoute:(context) => const AddUpdateFood(),
        listFoodsRoute:(context) => const ListFoods(),
        listAmSnacksRoute:(context) => const ListAmsnacks()


      },
    ));
}

enum MenuAction { logout }
class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [MenuActionsWidget(context: context,)],
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
                Navigator.pushNamed(context, coachUsersRoute);
              },
            ),
            ListTile(
              title: const Text('Register a  User'),
              onTap: () {
                // Navigate to Location 1
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, registerRoute);
              },
            ),
            ListTile(
              title: const Text('Foods'),
              onTap: () {
                // Navigate to Location 1
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, listFoodsRoute);
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