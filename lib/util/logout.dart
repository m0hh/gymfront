
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' show log;


Future<void> logout(context) async {
try {
  final _storage = const FlutterSecureStorage();
  await _storage.deleteAll();
  Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);

  } catch (error) {
    // Handle any errors that may occur during logout
    log(error.toString());
  }
}