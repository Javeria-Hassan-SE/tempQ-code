
import 'package:flutter/material.dart';

import '../constants/constants.dart';

AppBar defaultAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    iconTheme: const IconThemeData(
        color: Colors.white),
    leading: const BackButton(
    ),
    backgroundColor: primaryColor,
    elevation: 0,
  );
}
