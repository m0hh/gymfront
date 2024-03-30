

import 'package:flutter/material.dart';

class ListCoachUsers extends StatefulWidget {
  const ListCoachUsers({super.key});

  @override
  State<ListCoachUsers> createState() => _ListCoachUsersState();
}

class _ListCoachUsersState extends State<ListCoachUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your users"),
        ),
      body: const Text("Hello World"),
    );
  }
}