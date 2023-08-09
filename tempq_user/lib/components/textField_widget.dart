import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class TextFieldWidget extends StatefulWidget {
  final String text;
  final TextInputType textInputType;
  final IconData icon;
  final Color textColor;
  final Color iconColor;
  final bool obscureText;
  final TextEditingController textController;
  const TextFieldWidget({Key? key, required this.text, required this.textInputType, required this.icon, required this.textColor, required this.iconColor, required this.obscureText, required this.textController}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    widget.textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => TextFormField(
    keyboardType: widget.textInputType,
    style: TextStyle(color: widget.textColor, fontSize: 14),
    decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        icon: Icon(widget.icon, color: widget.iconColor,),
        labelText: widget.text,
        labelStyle: TextStyle(color: widget.textColor)
    ),
    obscureText: widget.obscureText,
    controller: widget.textController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter valid input';
      }
      if (widget.textInputType == TextInputType.name){
        if (!isAlpha(value)) {
          return 'Enter valid name';
        }
      }
       if (widget.textInputType == TextInputType.emailAddress){
        if (!isEmail(value)) return 'Enter valid email';
      }
       if (widget.textInputType == TextInputType.phone){
        if (!isNumeric(value) || value.length != 11) return 'Enter valid contact';
      }
       if (widget.textInputType == TextInputType.visiblePassword){
        if (value.length < 6) return 'Your password must contain letters and numbers';
      }
      return null;
    },
  );
}




