import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../models/task_model.dart';
import '../../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Consumer ensures this widget rebuilds whenever TaskProvider calls notifyListeners()
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;

        return tasks.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to EasyTask",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Add your First Task.",
                  style: TextStyle(fontSize: 16)),
              Text("Click on + icon",
                  style: TextStyle(fontSize: 16, color: Colors.green)),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskCard(
              task: task,
              // We call the provider method to delete
              onDelete: () {
                context.read<TaskProvider>().deleteTask(task);
              },
            );
          },
        );
      },
    );
  }
}