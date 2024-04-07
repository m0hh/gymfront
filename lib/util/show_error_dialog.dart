


import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gymfront/util/genericDialog.dart';

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

void showSuccessDialog(BuildContext context, message){
   final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content:  Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
}

Future<void> showNewErrorDialog (BuildContext context, String text){
  return showGenericDialog(context: context,
   title: "An Error Has Ocurred",
    content: text,
     optionsBuilder: () =>{
      'OK' : null,
     });

}


Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog(context: context,
   title: "Delete",
    content: "Are you sure you want to delete",
     optionsBuilder: () => {
      'No' : false,
      'Delete' : true
     }).then((value) => value ?? false);
}


Future<void> showErrorDialogBuild(BuildContext context, String error) async {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  });
}