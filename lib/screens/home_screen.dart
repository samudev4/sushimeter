import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushimeter/constants/app_colors.dart';
import 'package:sushimeter/constants/app_strings.dart';
import 'package:sushimeter/screens/counter_screen.dart';
import 'package:sushimeter/screens/history_screen.dart';
import 'package:sushimeter/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CounterScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorTextoOn(context),
            );
          }
          return GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.colorTextoOff(context),
          );
        }),
        backgroundColor: AppColors.colorFondoNavigationBar(context),
        indicatorColor: AppColors.colorIndicatorColor(context),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Image.asset(
              AppStrings.rutaIconoSushiOff,
              height: 24,
              width: 24,
              color: AppColors.colorIconosOff(context),
            ),
            selectedIcon: Image.asset(
              AppStrings.rutaIconoSushiOn,
              height: 24,
              width: 24,
              color: AppColors.colorIconosOn(context),
            ),
            label: AppStrings.textoSushi,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.leaderboard_outlined,
              size: 24,
              color: AppColors.colorIconosOff(context),
            ),
            selectedIcon: Icon(
              Icons.leaderboard,
              size: 24,
              color: AppColors.colorIconosOn(context),
            ),
            label: AppStrings.textoHistorial,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              size: 24,
              color: AppColors.colorIconosOff(context),
            ),
            selectedIcon: Icon(
              Icons.settings,
              size: 24,
              color: AppColors.colorIconosOn(context),
            ),
            label: AppStrings.textoAjustes,
          ),
        ],
      ),
    );
  }
}
