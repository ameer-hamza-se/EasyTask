import 'package:flutter/material.dart';

void main() {
  runApp(EasyTaskApp());
}

class EasyTaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyTask',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

// -------------------------------------------------------------
// TASK MODEL (simple, no date, only material.dart used)
// -------------------------------------------------------------
class Task {
  final String id;
  final String title;
  final String description;
  final String priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
  });
}

// -------------------------------------------------------------
// HOME SCREEN
// -------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  void _addTask() async {
    final Task? newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() {
        tasks.insert(0, newTask); // newest first
      });
    }
  }

  void _deleteTask(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Task?"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                tasks.removeWhere((t) => t.id == id);
              });
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.check_circle_outline),
            SizedBox(width: 8),
            Text("EasyTask"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => CommunityScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: tasks.isEmpty ? _emptyState() : _taskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 70, color: Colors.green.shade300),
          SizedBox(height: 14),
          Text("No tasks yet", style: TextStyle(fontSize: 18)),
          SizedBox(height: 6),
          Text("Tap + to add your first task"),
        ],
      ),
    );
  }

  Widget _taskList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];
        return Card(
          elevation: 2,
          child: ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text(t.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (t.description.isNotEmpty) Text(t.description),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.flag, size: 14),
                    SizedBox(width: 4),
                    Text(t.priority),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () => _deleteTask(t.id),
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------
// ADD TASK SCREEN (title, description, priority)
// -------------------------------------------------------------
class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _priority = "Normal";

  void _saveTask() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Task title required")));
      return;
    }

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      priority: _priority,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Task Title", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 14),

            Text("Description", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            TextField(
              controller: _descCtrl,
              decoration: InputDecoration(
                hintText: "Task description (optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 14),

            Text("Priority", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ["Low", "Normal", "High"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _priority = v!),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: Text("Save Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// PLACEHOLDER SCREENS
// -------------------------------------------------------------
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(child: Text("Settings screen (coming soon)")),
    );
  }
}

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community")),
      body: Center(child: Text("Community screen (coming soon)")),
    );
  }
}
