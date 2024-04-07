import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/conf.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/util/menuBar.dart';
import 'package:gymfront/util/show_error_dialog.dart';
import 'package:http/http.dart' as http;


class ListAmsnacks extends StatefulWidget {
  const ListAmsnacks({super.key});

  @override
  State<ListAmsnacks> createState() => _ListAmsnacksState();
}

class _ListAmsnacksState extends State<ListAmsnacks> {
    final _storage = const FlutterSecureStorage();


    Future<String> _getAmSnacks() async {

    final url = Uri.parse('$baseUrl/v1/meals/amsnack/get');
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
        title: const Text("Your am snacks"),
        actions: [
          //  IconButton(
          //   onPressed: () =>{Navigator.pushNamed(context, addUpdateFoodRoute)},
          //   icon: const Icon(Icons.add)),
            MenuActionsWidget(context: context,),
            ]
        ),
      body: FutureBuilder(
        future:_getAmSnacks() ,
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              String result = snapshot.data ??  "error";
              if (result == "error"){
                showErrorDialogBuild(context, "An Error has occured");
              }else if(result == "login"){
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
              }
              late final Map<String, dynamic> data;
              try {
                data = jsonDecode(result) as Map<String, dynamic>;
              } on Exception {
                data = {};
              }
              return ListView.builder(
                itemCount: data["am_snacks"]?.length ?? 0,
                itemBuilder: (context, index) {
                  var am_snacks = data["am_snacks"][index];
                    List<String> foodNames = [];
                    for (var food in am_snacks["food"]) {
                      foodNames.add(food['food_name']);
                    }
                  return ListTile(
                    // onTap: () {
                    //   Navigator.pushNamed(context, addUpdateFoodRoute, arguments:foods );
                    // },
                    title: Text(
                      foodNames.join(", "),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      ),
                    // trailing: IconButton(
                    //   onPressed: () async{
                    //     final shouldDelete = await showDeleteDialog(context);
                    //     if (shouldDelete){
                    //       final res = await _deleteFood(foods["id"]);
                    //       switch (res){
                    //         case "login":
                    //           Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
                    //           break;
                    //         case "error":
                    //           showErrorDialog(context, "An Error has occured");
                    //           break;
                    //         case "conflict":
                    //         showErrorDialog(context,"Cannot delete this food because there is a meal that have it, delete the meal first");
                    //         default:
                    //           setState(() {});
                    //           break;
                    //       }

                    //     }
                    //   },
                    //   icon: const Icon(Icons.delete),

                    // ),
                    
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
