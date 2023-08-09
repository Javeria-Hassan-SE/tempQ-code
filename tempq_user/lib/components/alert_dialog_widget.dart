
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AlertDialogWidget extends StatefulWidget {
  final Icon icon;
  final String text;
  final String content;
  final String button1Text;
  final String button2Text;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  const AlertDialogWidget({Key? key, required this.icon, required this.text, required this.content, required this.button1Text, required this.button2Text, required this.onPressed1, required this.onPressed2}) : super(key: key);

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.icon,
      title: Text(widget.text,textAlign: TextAlign.center, style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20),),
      content: Text(widget.content, textAlign: TextAlign.center,),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: greyColor),
            onPressed: widget.onPressed1,
            child: Text(widget.button1Text)),
        TextButton(
            style: TextButton.styleFrom(primary: headingColor),
        onPressed: widget.onPressed2,
        child: Text(widget.button2Text))
      ],

    );
  }
}
