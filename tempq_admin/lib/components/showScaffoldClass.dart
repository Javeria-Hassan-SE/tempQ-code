import 'package:flutter/material.dart';

class ShowScaffoldClass{
  void showScaffoldMessage(BuildContext context, String message,  Color color){
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text(message,
          style: TextStyle(color: color),
        )));
  }
}