import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/profile.dart';
import 'package:flutter_ar_app/pages/settings.dart';
import 'package:flutter_ar_app/pages/unityinit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'ar.dart';


class NavArPage extends StatefulWidget {
  NavArPage({Key? key}) : super(key: key);

  @override
  State<NavArPage> createState() => _NavArPageState();
}

class _NavArPageState extends State<NavArPage> {

  int _selectedIndex = 1;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ARPage(),
    ProfilePage(),
    SettingsPage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(255, 57, 123, 255),
        shadowColor: Color.fromARGB(84, 0, 0, 0),
        title: const Text('ARGraduateApp', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500)), //, style: TextStyle(fontFamily: "Poppins", weight: 100)
        leading: Icon(Icons.center_focus_strong_outlined),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Color.fromARGB(255, 57, 123, 255),
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.grey,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.filter_center_focus_outlined,
                  text: 'AR',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

}