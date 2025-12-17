import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  // --- State ---
  final List<Task> _tasks = [];
  String _userName = "Guest User";
  String _userEmail = "guest@easytask.com";

  // --- Constructor ---
  // Checks if a user is already logged in when the app starts
  TaskProvider() {
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userName = user.displayName ?? "No Name";
      _userEmail = user.email ?? "";
      notifyListeners();
    }
  }

  // --- Getters ---
  List<Task> get tasks => List.unmodifiable(_tasks);
  String get userName => _userName;
  String get userEmail => _userEmail;

  int get totalTasks => _tasks.length;
  int get highPriorityTasks => _tasks.where((t) => t.priority == 'High').length;

  // --- Actions ---

  // Call this after Login or Signup to update the Drawer immediately
  void setUser(String name, String email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _sortTasks();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    _sortTasks();
    notifyListeners();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      int aP = a.priority == 'High' ? 3 : a.priority == 'Medium' ? 2 : 1;
      int bP = b.priority == 'High' ? 3 : b.priority == 'Medium' ? 2 : 1;

      final int sortPriority = bP.compareTo(aP);
      if (sortPriority != 0) return sortPriority;

      return a.dueDate.compareTo(b.dueDate);
    });
  }
}