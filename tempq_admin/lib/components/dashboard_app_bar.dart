
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../responsive/responsive.dart';
import '../screens/dashboard/profile/profile_screen.dart';


class DashboardAppBar extends StatefulWidget {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
      // IconButton(
      //   icon: const Icon(Icons.menu, color: primaryColor,),
      //   onPressed: context.read<MenuController>().controlMenu,
      //   iconSize: 24,
      // ),
      Expanded(
        child: Center(
          child: Text(
            "Admin",
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ProfileCard(),
      ]
    );
  }
}


class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(80)),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        child: Row(
          children: [
            Image.asset(
              "assets/images/profile-icon.png",
              height: 24,
            ),
            if (!Responsive.isMobile(context))
              const Padding(
                padding:
                EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text(userName,
                  style: TextStyle(color: blackColor),),
              ),
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen()));
        },
      ),
    );
  }
}
