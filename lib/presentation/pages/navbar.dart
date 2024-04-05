import 'package:absensi_glagahwangi/presentation/pages/attendance/attendance.dart';
import 'package:absensi_glagahwangi/presentation/pages/profile/profile.dart';
import 'package:flutter/material.dart';

import '../../utils/color_palette.dart';
import 'home/home.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  final page = [
    Home(),
    Attendance(),
    Profile(),
    // Add more pages as needed
  ];

  List<Widget>? _widgetOptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPages();
    });
  }

  initPages() async {
    _widgetOptions = [const Attendance()];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 2, color: ColorPalette.divider),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              iconTheme: MaterialStateProperty.all(
                const IconThemeData(
                  color: ColorPalette.navbar_off,
                  size: 24,
                ),
              ),
              indicatorColor: Colors.transparent,
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontFamily: 'Manrope',
                  color: ColorPalette.main_green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            child: NavigationBar(
              height: 64,
              elevation: 0,
              selectedIndex: index,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: const Duration(milliseconds: 200),
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon:
                      Icon(Icons.dashboard, color: ColorPalette.main_green),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.fingerprint_outlined),
                  selectedIcon:
                      Icon(Icons.fingerprint, color: ColorPalette.main_green),
                  label: 'Scan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon:
                      Icon(Icons.person, color: ColorPalette.main_green),
                  label: 'Profile',
                ),
                // NavigationDestination(
                //   icon: Icon(Icons.favorite_outline),
                //   selectedIcon: Icon(Icons.favorite),
                //   label: 'Favorites',
                // ),
              ],
            ),
          ),
        ],
      ),
      body: page[index],
    );
  }
}
