import 'package:flutter/material.dart';

void main() {
  runApp(const EasyTaskApp());
}

class EasyTaskApp extends StatelessWidget {
  const EasyTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyTask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1F1F1F), // dark grey background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2C),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white70,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3A3A3A),
          foregroundColor: Colors.white70,
        ),
        cardColor: const Color(0xFF2B2B2B),
        iconTheme: const IconThemeData(color: Colors.white70),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> tasks = [];

  void _openAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2B2B2B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return AddTaskSheet(onAdd: _addTask);
      },
    );
  }

  void _addTask(String title, String desc, DateTime date, String priority) {
    setState(() {
      tasks.add({
        'title': title,
        'desc': desc,
        'dueDate': date,
        'priority': priority,
      });
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EasyTask")),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          "Add Task",
          style: TextStyle(color: Colors.white38, fontSize: 20),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          Color priorityColor;
          if (task['priority'] == 'High') {
            priorityColor = Colors.grey.shade400;
          } else if (task['priority'] == 'Medium') {
            priorityColor = Colors.grey.shade500;
          } else {
            priorityColor = Colors.grey.shade600;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.task_alt),
              title: Text(
                task['title'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task['desc'].isNotEmpty)
                    Text(
                      task['desc'],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(height: 3),
                  Text(
                    "Due: ${task['dueDate'].day}/${task['dueDate'].month}/${task['dueDate'].year}",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 16, color: Colors.white38),
                      const SizedBox(width: 5),
                      Text(
                        task['priority'],
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskSheet extends StatefulWidget {
  final Function(String, String, DateTime, String) onAdd;

  const AddTaskSheet({super.key, required this.onAdd});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime? selectedDate;
  String selectedPriority = 'Low';

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.grey,
              onSurface: Colors.white70,
              surface: Color(0xFF2B2B2B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Add New Task",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Color(0xFF3A3A3A),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  labelText: 'Short Description',
                  labelStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Color(0xFF3A3A3A),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF3A3A3A),
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        labelStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Low', 'Medium', 'High']
                          .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          p,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.date_range, color: Colors.white70),
                    label: Text(
                      selectedDate == null
                          ? "Set Date"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A3A3A),
                      foregroundColor: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty || selectedDate == null) return;
                    widget.onAdd(titleController.text, descController.text,
                        selectedDate!, selectedPriority);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text("Add Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
