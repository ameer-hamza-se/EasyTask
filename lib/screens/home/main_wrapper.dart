import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider if needed for sub-widgets
import '../../widgets/app_drawer.dart';
import '../community_page.dart';
import '../settings_page.dart';
import 'home_screen.dart';
import 'task_addition_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 1;

  // We don't need 'tasks', 'addTask', 'deleteTask', or 'user info' here anymore.

  void _launchTaskAdditionScreen() async {
    // We don't need to pass a callback function anymore
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskAdditionScreen()),
    );
  }

  Widget _buildPage() {
    if (_selectedIndex == 0) return const CommunityPage();
    if (_selectedIndex == 1) return const HomeScreen(); // No arguments!
    return const SettingPage();
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle =
    ["Community", "EasyTask Home", "Settings"][_selectedIndex];

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text(appBarTitle,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
      drawer: const AppDrawer(), // No arguments!
      body: _buildPage(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton(
          onPressed: _launchTaskAdditionScreen,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.group, 0),
            _navItem(Icons.home, 1),
            _navItem(Icons.settings, 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final bool selected = index == _selectedIndex;
    return IconButton(
      icon: Icon(icon, color: selected ? Colors.white : Colors.green.shade200),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }
}