import 'package:absensi_glagahwangi/presentation/pages/attendance/attendance.dart';
import 'package:absensi_glagahwangi/presentation/pages/profile/profile.dart';
import 'package:flutter/material.dart';

import '../../utils/color_palette.dart';
import 'home/home.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static Page<void> page() => const MaterialPage<void>(child: NavBar());

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  final page = [
    const Home(),
    const Attendance(),
    const Profile(),
  ];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPages();
    });
  }

  initPages() async {

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
              iconTheme: WidgetStateProperty.all(
                const IconThemeData(
                  color: ColorPalette.navbarOff,
                  size: 24,
                ),
              ),
              indicatorColor: Colors.transparent,
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontFamily: 'Manrope',
                  color: ColorPalette.mainGreen,
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
                      Icon(Icons.dashboard, color: ColorPalette.mainGreen),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.fingerprint_outlined),
                  selectedIcon:
                      Icon(Icons.fingerprint, color: ColorPalette.mainGreen),
                  label: 'Absensi',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon:
                      Icon(Icons.person, color: ColorPalette.mainGreen),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ],
      ),
      body: page[index],
    );
  }
}
