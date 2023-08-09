import 'dart:async';
import 'package:flutter/services.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:tempq_admin/http/post_request.dart';
import '../../../components/alert_dialog_widget.dart';
import '../../../components/defaultAppBar.dart';
import '../../../components/display_image_widget.dart';
import '../../../constants/constants.dart';
import '../../../models/userModel.dart';
import '../../login/login_screen.dart';
import 'edit_company_name.dart';
import 'edit_name.dart';
import 'edit_phone.dart';

// This class handles the Page to display the user's info on the "Edit Profile" Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserModel.myUser;
    const String url =
        'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png';

    return Scaffold(
      appBar: defaultAppBar(context, "My Account"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: InkWell(
                  onTap: () {
                    // navigateSecondPage(const EditImagePage());
                  },
                  child: DisplayImage(
                    imagePath: user.userImage ?? url,
                    onPressed: () {},
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      navigateSecondPage(const EditNameFormPage());
                    },
                    icons: Icons.account_circle,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.purple,
                    ),
                    title: 'Name',
                    subtitle: user.userFullName,
                    titleStyle: const TextStyle(color: blackColor),
                    subtitleStyle: const TextStyle(color: greyColor),
                  ),
                  SettingsItem(
                    onTap: () {
                      //navigateSecondPage(const EditEmailFormPage());
                    },
                    icons: Icons.email,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: const Color(0xff0482b9),
                    ),
                    title: 'Email',
                    subtitle: user.userEmail,
                    titleStyle: const TextStyle(color: blackColor),
                    subtitleStyle: const TextStyle(color: greyColor),
                  ),
                  SettingsItem(
                    onTap: () {
                      navigateSecondPage(const EditPhoneFormPage());
                    },
                    icons: Icons.phone,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Phone',
                    subtitle: user.userContact,
                    titleStyle: const TextStyle(color: blackColor),
                    subtitleStyle: const TextStyle(color: greyColor),
                  ),
                  SettingsItem(
                    onTap: () {
                      navigateSecondPage(const EditCompanyNameFormPage());
                    },
                    icons: Icons.store,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.pink,
                    ),
                    title: 'Company Name',
                    subtitle: user.userCompany,
                    titleStyle: const TextStyle(color: blackColor),
                    subtitleStyle: const TextStyle(color: greyColor),
                  ),
                  SettingsItem(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialogWidget(
                                icon: const Icon(
                                  Icons.logout,
                                  size: 40,
                                  color: redColor,
                                ),
                                text: 'Are you Sure?',
                                content:
                                    'Do you want to Sign Out?',
                                button1Text: 'No',
                                button2Text: 'Yes',
                                onPressed1: () {
                                  Navigator.pop(context);
                                },
                                onPressed2: () {
                                  var obj = SendPostRequest();
                                  obj.saveLoginSession("","");

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder:
                                  (context) =>
                                  const LoginScreen()
                                  ));
                                },
                              ));
                    },
                    icons: Icons.exit_to_app_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: "Sign Out",
                    titleStyle: const TextStyle(color: blackColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Refreshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }



  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
