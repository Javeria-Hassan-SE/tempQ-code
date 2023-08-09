import 'package:tempq_admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

import '../../../components/defaultAppBar.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   darkNotifier.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    // bool isDark = darkNotifier.value;
    return Scaffold(
      appBar: defaultAppBar(context, titleSetting),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.fingerprint,
                  iconStyle: IconStyle(
                    iconsColor: secondaryColor,
                    withBackground: true,
                    backgroundColor: redColor,
                  ),
                  title: 'Privacy',
                  titleStyle: const TextStyle(color: blackColor),
                  subtitle: "Lock tempQ to improve your privacy",
                  subtitleStyle: TextStyle(color: greyColor),
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    iconsColor: secondaryColor,
                    backgroundColor: purpleColor,
                  ),
                  title: 'About',
                  titleStyle: const TextStyle(color: blackColor),
                  subtitle: learnMore,
                  subtitleStyle: const TextStyle(color: greyColor),
                ),
              ],
            ),
            // SettingsGroup(
            //   items: [
            //     SettingsItem(
            //       onTap: () {},
            //       icons: Icons.dark_mode_rounded,
            //       iconStyle: IconStyle(
            //         iconsColor: secondaryColor,
            //         withBackground: true,
            //         backgroundColor: greyColor,
            //       ),
            //       title: 'Dark Mode',
            //       subtitle:  isDarkTheme ? 'DarkMode' : 'LightMode',
            //       titleStyle: const TextStyle(color: blackColor),
            //       subtitleStyle: const TextStyle(color: greyColor),
            //       trailing: Switch(
            //         value: isDarkTheme,
            //         onChanged: (value) {
            //           setState(() {
            //             isDarkTheme = value;
            //           });
            //         },
            //       ),
            //     ),
            //
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
