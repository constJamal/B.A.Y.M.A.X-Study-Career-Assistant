import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'roadmap_screen.dart';
import 'architect_screen.dart';
import 'skill_forge_screen.dart';
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
    const ArchitectScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConfig.accentBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: "Roadmap",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_rounded),
            label: "Forge",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.architecture_rounded),
            label: "Architect",
          ),
        ],
      ),
    );
  }
}
