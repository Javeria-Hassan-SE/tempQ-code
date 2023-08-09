import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Size size;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked, required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
        foregroundColor:
          Theme.of(context).colorScheme.onSecondaryContainer,
          backgroundColor: headingColor,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
    onPressed: onClicked,
  child: Container(
      alignment: Alignment.center,
      height: 50.0,
      width: size.width * 0.3,
      padding: const EdgeInsets.all(0),
      child:  Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
            fontWeight: FontWeight.w400,
          color: whiteColor
        ),
      ),
  ),
  );
}
