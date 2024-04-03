
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/constants/routes.dart';
import 'package:gymfront/main.dart';
import 'package:gymfront/util/menuBar.dart';
import 'package:gymfront/util/show_error_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:gymfront/conf.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymfront/auth/service.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;
  final _storage = const FlutterSecureStorage();



  Future<void> _registerUser(name, email, password, registerButtonContext) async {

    final url = Uri.parse('$baseUrl/v1/users');
    final token = await _storage.read(key: "token");

    try {

      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          "name": name,
          "email": email,
          "password": password,
        }),
      );
      
      if (response.statusCode == 202) {

        showSuccessDialog(registerButtonContext, "Registered Successfully");
        Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(registerButtonContext).pushNamedAndRemoveUntil(homeRoute, (route) => false); 
        });
      } else if(response.statusCode == 400){
        showErrorDialog(registerButtonContext, "Oops! Something went wrong. Please try again.");

      
      }else if (response.statusCode == 403){
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
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [MenuActionsWidget(context: context)],
    ),
    body: Column(
      children: [
        TextField(
          controller: _name,
          decoration: const InputDecoration(hintText: "Enter Your Trainee Name",),
        ),
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: "Enter Your Trainee Email",),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter Your Trainee Password",),
        ),
        TextButton(
          onPressed: ()  async{
            final name = _name.text;
            final email = _email.text;
            final password = _password.text;
            final registerButtonContext = context;
            await _registerUser(name, email, password, registerButtonContext);
          }, 
          child: const Text('Register'),
        ),
      ],
    ),
    );
  }
}

