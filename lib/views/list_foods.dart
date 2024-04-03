

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/conf.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/main.dart';
import 'package:gymfront/util/logout.dart';
import 'package:gymfront/util/menuBar.dart';
import 'package:gymfront/util/show_error_dialog.dart';
import 'package:http/http.dart' as http;


class ListFoods extends StatefulWidget {
  const ListFoods({super.key});

  @override
  State<ListFoods> createState() => _ListFoodsState();
}

class _ListFoodsState extends State<ListFoods> {
  final _storage = const FlutterSecureStorage();



  Future<String> _getFoods() async {

    final url = Uri.parse('$baseUrl/v1/meals/food/get');
    final token = await _storage.read(key: "token");

    try {

      final response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      if (response.statusCode == 200) {
        return response.body;
      }else if (response.statusCode == 403){
        return "login";
      }else if (response.statusCode == 401){
        return "login";
      }else {
        return "error";
      
      }
    } on Exception catch (e) {
        return "error";
    }

 

  }

    Future<String> _deleteFood(int id) async {

    final url = Uri.parse('$baseUrl/v1/meals/food/delete/$id');
    final token = await _storage.read(key: "token");

    try {

      final response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      if (response.statusCode == 204) {
       return _getFoods();
      }else if (response.statusCode == 403){
        return "login";
      }else if (response.statusCode == 401){
        return "login";
      }else if (response.statusCode == 409){
        return "conflict";
      }else {
        return "error";
      
      }
    } on Exception catch (e) {
        return "error";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your foods"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
          } 
        ),
        actions: [
           IconButton(
            onPressed: () =>{Navigator.pushNamed(context, addFoodRoute)},
            icon: const Icon(Icons.add)),
            MenuActionsWidget(context: context,),
            ]
        ),
      body: FutureBuilder(
        future:_getFoods() ,
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              String result = snapshot.data ??  "error";
              if (result == "error"){
                showErrorDialog(context, result);
              }else if(result == "login"){
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
              }
              final data = jsonDecode(result) as Map<String, dynamic>;
              return ListView.builder(
                itemCount: data["foods"].length,
                itemBuilder: (context, index) {
                  final foods = data["foods"][index];
                  return ListTile(
                    title: Text(
                      foods["food_name"] + " Serving " + foods["serving"] ,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      ),
                    trailing: IconButton(
                      onPressed: () async{
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete){
                          final res = await _deleteFood(foods["id"]);
                          switch (res){
                            case "login":
                              Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
                              break;
                            case "error":
                              showErrorDialog(context, "An Error has occured");
                              break;
                            case "conflict":
                            showErrorDialog(context,"Cannot delete this food because there is a meal that have it, delete the meal first");
                            default:
                              setState(() {});
                              break;
                          }

                        }
                      },
                      icon: const Icon(Icons.delete),

                    ),
                    
                  );
                },
              );
            default:
            return const CircularProgressIndicator();
          }
        },

      ),
    );
  }
}