import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  // --- State ---
  final List<Task> _tasks = [];
  final String _userName = "John Doe"; // In a real app, fetch this from Firebase Auth
  final String _userEmail = "john.doe@easytask.com";

  // --- Getters ---
  List<Task> get tasks => List.unmodifiable(_tasks);
  String get userName => _userName;
  String get userEmail => _userEmail;

  int get totalTasks => _tasks.length;
  int get highPriorityTasks => _tasks.where((t) => t.priority == 'High').length;

  // --- Actions ---

  void addTask(Task task) {
    _tasks.add(task);
    _sortTasks();
    notifyListeners(); // This updates all screens listening to this provider
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