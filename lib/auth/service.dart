import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymfront/errors/errors.dart';
import 'package:http/http.dart' as http;
import 'package:gymfront/conf.dart'; // Assuming your config is here

class AuthenticationService {
  final _storage = const FlutterSecureStorage();


  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v1/tokens/authentication'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
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
        return true;
      } else {
        // Handle other status codes and errors
        return false;
      }
    } catch (e) {
      // Handle network errors
      return false;
    }
  }

  Future<void> checkAndRefreshToken() async {
    final token = await _storage.read(key: 'token');
    final expiryString = await _storage.read(key: 'expiry');
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    


    if (token == null || expiryString == null || email == null || password == null) {
      // No token or expiry stored, user needs to login
      throw UnAuthenticatedError(); // Custom error type
    }

    await login(email, password);
  }

    Future<bool> isLoggedIn() async {
    try {
      await checkAndRefreshToken(); // Check and refresh if needed
      return true; // If no exceptions, user is considered logged in
    } on UnAuthenticatedError {
      return false;
    }
  }
}