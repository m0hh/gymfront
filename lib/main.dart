

import 'package:flutter/material.dart';
import 'package:gymfront/auth/service.dart';
import 'package:gymfront/views/login_view.dart';

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
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page")),
    );
  }
}
