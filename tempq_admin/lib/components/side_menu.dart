import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tempq_admin/screens/dashboard/settings/settings_page.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:tempq_admin/screens/dashboard/users/users_list.dart';
import 'package:tempq_admin/screens/main/main_screen.dart';

import '../constants/constants.dart';
import '../controller/menu_controller.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/payments/paymentCardInfo.dart';
import '../screens/payments/view_user_invoices.dart';
import '../screens/sensors/sensor_category.dart';
import '../screens/sensors/showSensors.dart';


class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return
      Drawer(
        backgroundColor: primaryColor,
        width: MediaQuery.of(context).size.width*0.6,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Row(
                  children: [
                    Image.asset("assets/images/app_logo.jpeg"),
                  ],
                ),
                accountEmail: null,
                decoration: const BoxDecoration(
                    color: secondaryColor
                ),
              ),
              DrawerListTile(
                title: "Dashboard",
                iconSrc: Icons.dashboard,
                press: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (context) => MenuController(),
                            ),
                          ],
                          child: const MainScreen(),
                        ),
                      )).then(onGoBack);
                },
              ),
              DrawerListTile(
                title: "Users",
                iconSrc: Icons.people_alt,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const  UsersList())).then(onGoBack);
                },
              ),

              DrawerListTile(
                title: "Device Categories",
                iconSrc: Icons.category,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const  SensorCategory())).then(onGoBack);
                },
              ),
              DrawerListTile(
                title: "Sensors",
                iconSrc: Icons.sensors,
                press: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const  ShowSensors())).then(onGoBack);
                },
              ),
              DrawerListTile(
                title: "Notifications",
                iconSrc: Icons.notifications,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())).then(onGoBack);
                },
              ),
              DrawerListTile(
                title: "User Subscriptions",
                iconSrc: Icons.atm,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   PdfListScreen())).then(onGoBack);
                },
              ),
              DrawerListTile(
                title: "Settings",
                iconSrc: Icons.settings,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())).then(onGoBack);
                },
              ),
            ],
          ),
        ),
      );
    //);
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData iconSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        iconSrc,
        color: secondaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(color: secondaryColor, fontSize: bodyFontSize),
      ),
    );
  }

}
