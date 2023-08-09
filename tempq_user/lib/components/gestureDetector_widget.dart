import 'package:flutter/material.dart';

import '../constants/constants.dart';

class GestureDetectorWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

   const GestureDetectorWidget({
    Key? key, required this.onTap, required this.text,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Text(text,
    style: const TextStyle(
      fontSize: bodyFontSize,
      color: primaryColor
    ),
  )
  );
}
