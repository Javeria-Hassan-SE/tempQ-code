
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PaymentInfo {
  final IconData? iconSrc;
  final String?  charges, limit;
  final Color? color;

  PaymentInfo({
    this.iconSrc,
    this.charges,
    this.limit,
    this.color,
  });
}

List PaymentInfoData = [
  PaymentInfo(
    charges: "10\$",
    iconSrc: Icons.money,
    limit: "1 per month",
    color: primaryColor,
  ),
  PaymentInfo(
    charges: "50\$",
    iconSrc: Icons.monetization_on,
    limit: "6 per month",
    color: Colors.yellow,
  ),

];
