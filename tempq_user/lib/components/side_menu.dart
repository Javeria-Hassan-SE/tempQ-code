import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide MenuController;
import '../constants/constants.dart';
import '../controller/menu_controller.dart';
import '../screens/main/main_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/payments/billing_and_payments.dart';
import '../screens/payments/get_invoices.dart';
import '../screens/settings/settings_page.dart';


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
                          child:  MainScreen(),
                        ),
                      )).then(onGoBack);
                },
              ),

              DrawerListTile(
                title: "Mu Subscriptions",
                iconSrc: Icons.atm,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const BillingPayments())).then(onGoBack);
                },
              ),
              DrawerListTile(
                title: "My Invoices",
                iconSrc: Icons.atm,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   PdfListScreen())).then(onGoBack);
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
    setState(() {

    });
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
