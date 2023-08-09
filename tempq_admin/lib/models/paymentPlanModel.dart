
import 'package:flutter/material.dart';

class PaymentInfo {
  final IconData? iconSrc;
   String?  charges, limit;
  final Color? color;

  PaymentInfo({
    this.iconSrc,
    this.charges,
    this.limit,
    this.color,
  });
  static PaymentInfo activeDevices = PaymentInfo(
      iconSrc: Icons.money,
      charges: '0',
      limit: '0',
      color: Colors.blue
  );
  static PaymentInfo disableDevices = PaymentInfo(
      iconSrc: Icons.monetization_on,
      charges: '0',
      limit: '0',
      color: Colors.yellow
  );

  static List paymentInfoData = [
    activeDevices,
    disableDevices
  ];
}


// List PaymentInfoData = [
//   PaymentInfo(
//     charges: "10\$",
//     iconSrc: Icons.money,
//     limit: "1 per month",
//     color: primaryColor,
//   ),
//   PaymentInfo(
//     charges: "50\$",
//     iconSrc: Icons.monetization_on,
//     limit: "6 per month",
//     color: Colors.yellow,
//   ),
//
// ];
