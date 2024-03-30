
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:gymfront/conf.dart';
import 'dart:convert';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _storage = const FlutterSecureStorage();



  Future<void> _registerUser( email, password, loginButtonContext) async {

    final url = Uri.parse('$baseUrl/v1/tokens/authentication');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          "email": email,
          "password": password,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _storage.write(
          key: 'token',
          value: data['authentication_token']['token'],
        );
        await _storage.write(
          key: 'expiry',
          value: data['authentication_token']['expiry'].toString(),
        );
        await _storage.write(
          key: 'role',
          value: data['user']['role'],
        );
        await _storage.write(
          key: 'email',
          value: email,
        );
        await _storage.write(
          key: 'password',
          value: password,
        );
      } else if(response.statusCode == 400){
          ScaffoldMessenger.of(loginButtonContext).showSnackBar(
          const SnackBar(
            content: Text("Oops! Something went wrong. Please try again."),
          ),
        );
      
      }else if(response.statusCode == 401){
          ScaffoldMessenger.of(loginButtonContext).showSnackBar(
          const SnackBar(
            content: Text("Wrong Crednetials"),
          ),
        );
      
      }else if (response.statusCode == 422){
      
          final errors = jsonDecode(response.body) as Map<String, dynamic>;
          // Display specific errors from the server
          showDialog(
            context: loginButtonContext,
            builder: (context) => AlertDialog(
              title: const Text("Registration Error"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: errors.entries.map((error) {
                    return Text("${error.key}: ${error.value}");
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
      }else {
          ScaffoldMessenger.of(loginButtonContext).showSnackBar(
          const SnackBar(
            content: Text("Oops! Something went wrong. Please try again."),
          ),
        );
      
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(loginButtonContext).showSnackBar(
          const SnackBar(
            content: Text("Oops! Something went wrong. Please try again."),
          ),
        );
    }


  }
  
@override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
    ),
    body: Column(
      children: [
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
            final email = _email.text;
            final password = _password.text;
            final loginButtonContext = context;
            await _registerUser(email, password,loginButtonContext);
          }, 
          child: const Text('Login'),
        ),
      ],
    ),
    );
  }
}
