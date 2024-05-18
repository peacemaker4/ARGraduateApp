import 'package:bouncing_button/bouncing_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/pages/app_info_modal.dart';

import '../values/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  var switchValue = false;

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      child: Text("Settings", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 242, 244),
      body: Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          _header(),
          // SettingsGroup(
          //   items: [
          //     SettingsItem(
          //       onTap: () {},
          //       icons: Icons.edit,
          //       iconStyle: IconStyle(),
          //       title: 'Appearance',
          //       subtitle: "Make ARGraduateApp yours",
          //     ),
          //     SettingsItem(
          //       onTap: () {},
          //       icons: Icons.dark_mode_rounded,
          //       iconStyle: IconStyle(
          //         iconsColor: Colors.white,
          //         withBackground: true,
          //         backgroundColor: Colors.red,
          //       ),
          //       title: 'Dark mode',
          //       subtitle: "Automatic",
          //         trailing: CupertinoSwitch(
          //         value: switchValue,
          //         activeColor: CupertinoColors.activeBlue,
          //         onChanged: (bool? value) {
          //           setState(() {
          //             switchValue = value ?? false;
          //           });
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          
          SettingsGroup(
            items: [
              SettingsItem(
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                    ),
                    context: context, 
                    builder: (context) => AppInfoModal(),
                  );
                },
                icons: Icons.info_rounded,
                iconStyle: IconStyle(
                  backgroundColor: AppColors.primaryColor,
                ),
                title: 'About',
                titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),
                subtitle: "Learn more about ARGraduateApp",
                subtitleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: "Montserrat",),
              ),
            ],
          ),
          // You can add a settings title
          SettingsGroup(
            settingsGroupTitle: "Account",
            settingsGroupTitleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: "Montserrat", ),
            items: [
              SettingsItem(
                onTap: () {
                  Auth().signOut().then((value){});
                },
                icons: Icons.exit_to_app_rounded,
                title: "Sign Out",
                titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),
              ),
            ],
          ),
        ],
      ),
),
    );
  }

}