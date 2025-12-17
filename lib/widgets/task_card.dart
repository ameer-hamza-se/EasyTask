import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
  });
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        // Outer decoration for Border and rounded corners
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), // 12 - 2 (border width) = 10
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Using green to keep your theme
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // shifts the shadow slightly down
            ),
          ], // Green border
        ),
        // ClipRRect ensures the green side panel follows the rounded corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: IntrinsicHeight( // Ensures the Right Side stretches to match the Left Side's height
            child: Row(
              children: [
                // === LEFT SIDE (Content) ===
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Task Title
                        Transform.translate(
                          offset: const Offset(5, 0),
                          child: Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Description Box (Gray Background)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 3. Priority and Date Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Priority
                            Transform.translate(
                              offset: const Offset(5, 2),
                              child: Text(
                                task.priority,
                                style: TextStyle( // <--- Remove 'const' here
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _getPriorityColor(task.priority), // <--- New dynamic color
                                ),
                              ),
                            ),
                            // Date
                            Text(
                              DateFormat("dd/MM/yyyy").format(task.dueDate),
                              style: const TextStyle(
                                color: Colors.redAccent, // Red color for date
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // === RIGHT SIDE (Delete Action) ===
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 70, // Fixed width for the sidebar
                    color: Colors.green, // Matches the border green
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.delete, // Trash can icon
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}