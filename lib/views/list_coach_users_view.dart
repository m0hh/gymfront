

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


class ListCoachUsers extends StatefulWidget {
  const ListCoachUsers({super.key});

  @override
  State<ListCoachUsers> createState() => _ListCoachUsersState();
}

class _ListCoachUsersState extends State<ListCoachUsers> {
  final _storage = const FlutterSecureStorage();



  Future<String> _getUsers() async {

    final url = Uri.parse('$baseUrl/v1/users/coach/get');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your users"),
        actions: [
           IconButton(
            onPressed: () =>{Navigator.pushNamed(context, registerRoute)},
            icon: const Icon(Icons.add)),
            MenuActionsWidget(context: context,),
            ]
        ),
      body: FutureBuilder(
        future:_getUsers() ,
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
                itemCount: data["users"].length,
                itemBuilder: (context, index) {
                  final user = data["users"][index];
                  return ListTile(
                    title: Text(
                      user["name"],
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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