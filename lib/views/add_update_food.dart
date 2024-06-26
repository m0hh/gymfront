import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/util/get_arguments.dart';
import 'package:gymfront/util/menuBar.dart';
import 'package:gymfront/util/show_error_dialog.dart';
import 'package:gymfront/views/list_foods.dart';
import 'package:http/http.dart' as http;
import 'package:gymfront/conf.dart';
import 'dart:convert';


class AddUpdateFood extends StatefulWidget {
  const AddUpdateFood({super.key});

  @override
  State<AddUpdateFood> createState() => _AddUpdateFoodState();
}



class _AddUpdateFoodState extends State<AddUpdateFood> {
  late final TextEditingController _foodName;
  late final TextEditingController _serving;
  late final TextEditingController _calories;
  Map<String, dynamic>?  widgetFood;
  final _storage = const FlutterSecureStorage();



  Future<void> _addFood(foodName, serving, calories, buttonContext) async {

    final url = Uri.parse('$baseUrl/v1/meals/food/add');
    final token = await _storage.read(key: "token");

    try {

      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, dynamic>{
          "food_name": foodName,
          "serving": serving,
          "calories": calories,
        }),
      );


      
      if (response.statusCode == 201) {

        showSuccessDialog(buttonContext, "Created Succesfully Successfully");
        Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListFoods())); 
        });
      } else if (response.statusCode == 403){
        Navigator.of(buttonContext).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      }else if (response.statusCode == 401){
        Navigator.of(buttonContext).pushNamedAndRemoveUntil(loginRoute, (route) => false); 
      } else if (response.statusCode == 422){
      
          final errors = jsonDecode(response.body) as Map<String, dynamic>;
          showErrorsDialog(buttonContext, errors);
      }else {
        showErrorDialog(buttonContext, "Oops! Something went wrong. Please try again.");
      
      }
    } on Exception catch (e) {
        showErrorDialog(buttonContext, "Oops! Something went wrong. Please try again.");
    }


  }

    Future<void> _updateFood(foodName, serving, calories, buttonContext, foodId) async {

    final url = Uri.parse('$baseUrl/v1/meals/food/update/$foodId');
    final token = await _storage.read(key: "token");

    try {

      final response = await http.patch(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, dynamic>{
          "food_name": foodName,
          "serving": serving,
          "calories": calories,
        }),
      );


      
      if (response.statusCode == 201) {

        showSuccessDialog(buttonContext, "Created Succesfully Successfully");
        Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListFoods())); 
        });
      } else if (response.statusCode == 403){
        Navigator.of(buttonContext).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      }else if (response.statusCode == 401){
        Navigator.of(buttonContext).pushNamedAndRemoveUntil(loginRoute, (route) => false); 
      } else if (response.statusCode == 422){
      
          final errors = jsonDecode(response.body) as Map<String, dynamic>;
          showErrorsDialog(buttonContext, errors);
      }else {
        showErrorDialog(buttonContext, "Oops! Something went wrong. Please try again.");
      
      }
    } on Exception catch (e) {
        showErrorDialog(buttonContext, "Oops! Something went wrong. Please try again.");
    }


  }
  
@override
  void initState(){
    _foodName = TextEditingController();
    _serving = TextEditingController();
    _calories = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _foodName.dispose();
    _serving.dispose();
    _calories.dispose();
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    widgetFood = context.getArgument<Map<String, dynamic>>();
    if (widgetFood != null){
      _foodName.text = widgetFood?["food_name"];
      _serving.text = widgetFood?["serving"];
      _calories.text =  widgetFood!["calories"].toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        actions: [MenuActionsWidget(context: context)],
    ),
    body: Column(
      children: [
        TextField(
          controller: _calories,
          keyboardType: TextInputType.number, // Set keyboard type to number
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only digits
          ],
          decoration: const InputDecoration(hintText: "Enter Your Caloires",),
        ),
        TextField(
          controller: _foodName,
          decoration: const InputDecoration(hintText: "Enter Your Food Name",),
        ),
        TextField(
          controller: _serving,
          decoration: const InputDecoration(hintText: "Enter Your Serving",),
        ),
        TextButton(
          onPressed: ()  async{
            if(widgetFood != null){
              final calories = int.parse(_calories.text);
              final foodName = _foodName.text;
              final serving = _serving.text;
              final buttonContext = context;
              await _updateFood(foodName, serving, calories, buttonContext, widgetFood?["id"]);
            }else{
              final calories = int.parse(_calories.text);
              final foodName = _foodName.text;
              final serving = _serving.text;
              final buttonContext = context;
              await _addFood(foodName, serving, calories, buttonContext);
            }

          }, 
          child: const Text('Add'),
        ),
      ],
    ),
    );
  }
}

