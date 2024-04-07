import 'package:flutter/material.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/util/menuBar.dart';

class MealsView extends StatefulWidget {
  const MealsView({super.key});

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  final List<List<String>> mealItems = [["am_snack", listAmSnacksRoute]];
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Text("Your foods"),
        actions: [MenuActionsWidget(context: context)],
      ),
      body:  ListView.builder(
      itemCount: mealItems.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton( // Use TextButton for clickable button
            onPressed: () => Navigator.pushNamed(context, mealItems[index][1]),
            child: Text(mealItems[index][0]),)
        );
      },
    ));
  }
}