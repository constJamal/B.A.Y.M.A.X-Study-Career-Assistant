import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'roadmap_screen.dart';
import 'skill_forge_screen.dart';
import 'study_buddy_screen.dart';
import '../core/constants.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const RoadmapScreen(),
    const SkillForgeScreen(),
    const StudyBuddyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConfig.primaryBrand,
        unselectedItemColor: AppConfig.textSecondary,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: "Roadmap",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high_rounded),
            label: "Forge",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: "Study Buddy",
          ),
        ],
      ),
    );
  }
}
