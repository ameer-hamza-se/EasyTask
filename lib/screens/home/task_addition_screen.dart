import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class TaskAdditionScreen extends StatefulWidget {
  // No callback required anymore
  const TaskAdditionScreen({super.key});

  @override
  State<TaskAdditionScreen> createState() => _TaskAdditionScreenState();
}

class _TaskAdditionScreenState extends State<TaskAdditionScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  String? _priority;
  DateTime? _date;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Colors.green.shade50,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(hintText: "Task Title"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _priority,
                        hint: const Text("Priority"),
                        items: ["High", "Medium", "Low"]
                            .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setState(() => _priority = v),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setState(() => _date = picked);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100),
                        child: Text(_date == null
                            ? "DUE"
                            : DateFormat("dd/MM/yyyy").format(_date!)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 45)),
                  child: const Text("Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_titleCtrl.text.isEmpty ||
                        _descCtrl.text.isEmpty ||
                        _priority == null ||
                        _date == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill all fields")));
                      return;
                    }

                    // --- PROVIDER CALL ---
                    // "listen: false" is important here because we are in a callback
                    // and don't need to rebuild this screen when the list changes.
                    Provider.of<TaskProvider>(context, listen: false).addTask(
                      Task(
                        title: _titleCtrl.text,
                        description: _descCtrl.text,
                        priority: _priority!,
                        dueDate: _date!,
                      ),
                    );

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}