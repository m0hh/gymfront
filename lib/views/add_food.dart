import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/util/menuBar.dart';
import 'package:gymfront/util/show_error_dialog.dart';
import 'package:gymfront/views/list_foods.dart';
import 'package:http/http.dart' as http;
import 'package:gymfront/conf.dart';
import 'dart:convert';


class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  late final TextEditingController _foodName;
  late final TextEditingController _serving;
  late final TextEditingController _calories;
  final _storage = const FlutterSecureStorage();



  Future<void> _addFood(foodName, serving, calories, registerButtonContext) async {

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

        showSuccessDialog(registerButtonContext, "Created Succesfully Successfully");
        Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListFoods())); 
        });
      } else if (response.statusCode == 403){
        Navigator.of(registerButtonContext).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      }else if (response.statusCode == 401){
        Navigator.of(registerButtonContext).pushNamedAndRemoveUntil(loginRoute, (route) => false); 
      } else if (response.statusCode == 422){
      
          final errors = jsonDecode(response.body) as Map<String, dynamic>;
          showErrorsDialog(registerButtonContext, errors);
      }else {
        showErrorDialog(registerButtonContext, "Oops! Something went wrong. Please try again.");
      
      }
    } on Exception catch (e) {
        showErrorDialog(registerButtonContext, "Oops! Something went wrong. Please try again.");
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
            final calories = int.parse(_calories.text);
            final foodName = _foodName.text;
            final serving = _serving.text;
            final registerButtonContext = context;
            await _addFood(foodName, serving, calories, registerButtonContext);
          }, 
          child: const Text('Add'),
        ),
      ],
    ),
    );
  }
}

