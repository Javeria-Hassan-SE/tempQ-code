import 'package:flutter/material.dart';

import '../constants/constants.dart';

class WelcomeBar extends StatelessWidget {
  const WelcomeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children:  [
             Text(
              titleWelcome,
              style: TextStyle(color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: headingFontSize),
            ),
            SizedBox(width: defaultPadding),
            Icon(Icons.waving_hand_sharp, color: yellowColor,),
          ],
        ),
         SizedBox(height: defaultPadding),
      ],
    );
  }

}
