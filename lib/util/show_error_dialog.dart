


import 'package:flutter/material.dart';

void showErrorsDialog(BuildContext context,Map<String, dynamic>  errors){
  showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
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
}

void showErrorDialog(BuildContext context,  error){
  ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(error),
          ),
        );
}