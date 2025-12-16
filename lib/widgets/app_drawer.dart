import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access data using Consumer or context.watch
    final taskProvider = context.watch<TaskProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.green),
                ),
                const SizedBox(height: 10),
                Text(taskProvider.userName, // Data from Provider
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text(taskProvider.userEmail, // Data from Provider
                    style:
                    const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in),
            title: const Text("Total Tasks"),
            trailing: Chip(label: Text(taskProvider.totalTasks.toString())),
          ),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: const Text("High Priority Tasks"),
            trailing: Chip(
              label: Text(taskProvider.highPriorityTasks.toString()),
              backgroundColor: Colors.red.shade100,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}