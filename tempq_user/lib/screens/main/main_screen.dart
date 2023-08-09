import 'package:flutter/material.dart' hide MenuController;
import 'package:provider/provider.dart';

import '../../components/dashboard_app_bar.dart';
import '../../components/side_menu.dart';
import '../../constants/constants.dart';
import '../../controller/menu_controller.dart';
import '../../responsive/responsive.dart';
import '../dashboard_screen.dart';



class MainScreen extends StatelessWidget {
   const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        // leading: const Icon(Icons.thermostat, color: whiteColor,
        // size: 24,),
        title: const DashboardAppBar(),
      ),
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
             const Expanded(
              flex: 5,
              child: DashboardScreen(),
            )
          ],
        ),
      ),
    );
  }
}
