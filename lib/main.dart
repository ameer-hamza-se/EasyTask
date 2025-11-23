import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EasyTaskApp());
}

class EasyTaskApp extends StatelessWidget {
  const EasyTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EASY TASK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green.shade300,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainWrapper(),
      },
    );
  }
}

// ================= SPLASH SCREEN ===================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Dismissible(
        key: const Key('splash_screen_dismissible_key'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (mounted && direction == DismissDirection.endToStart) {
            // Schedule the navigation to happen immediately in the next microtask.
            Future.microtask(() {
              Navigator.pushReplacementNamed(context, '/login');
            });
          }
        },
        background: Container(
          color: Colors.white,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Ink.image(
                  image: const AssetImage('assets/logo.png'), height: 200),
              //const SizedBox(height: 1),
              Transform.translate(
                offset: const Offset(0, -30),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("EASY",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("TASK",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Text("You won't be late anymore",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Swipe left to continue"),
                    Icon(Icons.arrow_back, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ================= LOGIN SCREEN ===================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;

  // Error texts
  String? emailError;
  String? passwordError;
  String? generalError;

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Make sure this asset exists in your pubspec.yaml
                          Ink.image(
                            image: const AssetImage('assets/logo.png'),
                            height: 160,
                            width: 160,
                            // Added errorBuilder in case image is missing to prevent crash
                            onImageError: (exception, stackTrace) {
                              // Handle missing image gracefully
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Transform.translate(
                              offset: const Offset(-10, 0),
                              child: const Column(
                                children: [
                                  Text("EASY",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold)),
                                  Text("TASK",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),
              const Text("User Name"),
              const SizedBox(height: 8),

              /// USERNAME FIELD
              TextField(
                controller: userCtrl,
                decoration: InputDecoration(
                  hintText: "Enter User Name",
                  prefixIcon: const Icon(Icons.person),
                  errorText: emailError,
                ),
              ),

              const SizedBox(height: 20),
              const Text("Password"),
              const SizedBox(height: 8),

              /// PASSWORD FIELD
              TextField(
                controller: passCtrl,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                  errorText: passwordError,
                ),
              ),

              if (generalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    generalError!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final email = userCtrl.text.trim();
                      final password = passCtrl.text.trim();

                      // Reset errors
                      setState(() {
                        emailError = null;
                        passwordError = null;
                        generalError = null;
                      });

                      // Empty validation
                      if (email.isEmpty || password.isEmpty) {
                        setState(() {
                          if (email.isEmpty) emailError = "Username is required";
                          if (password.isEmpty) {
                            passwordError = "Password is required";
                          }
                        });
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          // FIX: Added 'invalid-credential' to the check
                          if (e.code == 'user-not-found' ||
                              e.code == 'wrong-password' ||
                              e.code == 'invalid-email' ||
                              e.code == 'invalid-credential') {

                            emailError = "Incorrect username or password";
                            passwordError = "Incorrect username or password";

                          } else {
                            generalError = e.message;
                          }
                        });
                      } catch (e) {
                        setState(() {
                          generalError = "Unexpected error: ${e.toString()}";
                        });
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("First time on app? "),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      "Signup",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SIGNUP SCREEN ===================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullCtrl = TextEditingController();
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    fullCtrl.dispose();
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Ink.image(
                        image: AssetImage('assets/logo.png'), height: 120),
                    SizedBox(height: 6),
                    Text("EASY TASK",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text("Signup",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              const Text("Full Name"),
              const SizedBox(height: 8),
              TextField(
                controller: fullCtrl,
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              const Text("User Name"),
              const SizedBox(height: 8),
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(
                  hintText: "User Name",
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),
              const SizedBox(height: 15),
              const Text("Password"),
              const SizedBox(height: 8),
              TextField(
                controller: passCtrl,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: "Set Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon:
                        Icon(obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: userCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                        );

                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                    child: const Text("Signup",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text("Login",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= TASK MODEL ===================

class Task {
  final String title;
  final String description;
  final String priority;
  final DateTime dueDate;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });
}

// ================= DRAWER ===================

class AppDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final int totalTasks;
  final int highPriorityTasks;

  const AppDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.totalTasks,
    required this.highPriorityTasks,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(userName,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text(userEmail,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in),
            title: const Text("Total Tasks"),
            trailing: Chip(label: Text(totalTasks.toString())),
          ),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: const Text("High Priority Tasks"),
            trailing: Chip(
              label: Text(highPriorityTasks.toString()),
              backgroundColor: Colors.red.shade100,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

// ================= MAIN WRAPPER (REAL-TIME UPDATE) ===================

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 1;
  final List<Task> tasks = [];

  final String _userName = "John Doe";
  final String _userEmail = "john.doe@easytask.com";

  int get totalTasks => tasks.length;
  int get highPriorityTasks => tasks.where((t) => t.priority == 'High').length;

  // Add Task
  void addTask(Task task) {
    setState(() {
      tasks.add(task);
      _sortTasks();
    });
  }

  // Delete Task
  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
      _sortTasks();
    });
  }

  // Sorting
  void _sortTasks() {
    tasks.sort((a, b) {
      int aP = a.priority == 'High'
          ? 3
          : a.priority == 'Medium'
              ? 2
              : 1;
      int bP = b.priority == 'High'
          ? 3
          : b.priority == 'Medium'
              ? 2
              : 1;

      final int sortPriority = bP.compareTo(aP);
      if (sortPriority != 0) return sortPriority;

      return a.dueDate.compareTo(b.dueDate);
    });
  }

  // Opening the Add Task screen
  void _launchTaskAdditionScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskAdditionScreen(addTask: addTask),
      ),
    );
    // after returning, setState to ensure page rebuilds (Home will reflect new tasks)
    setState(() {});
  }

  // choose page dynamically so Home receives latest tasks
  Widget _buildPage() {
    if (_selectedIndex == 0) return const CommunityPage();
    if (_selectedIndex == 1)
      return HomeScreen(tasks: tasks, deleteTask: deleteTask);
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
      drawer: AppDrawer(
        userName: _userName,
        userEmail: _userEmail,
        totalTasks: totalTasks,
        highPriorityTasks: highPriorityTasks,
      ),
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

// ================= HOME SCREEN ===================

class HomeScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) deleteTask;

  const HomeScreen({super.key, required this.tasks, required this.deleteTask});

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Welcome to EasyTask",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Add your First Task.", style: TextStyle(fontSize: 16)),
                Text("Click on + icon",
                    style: TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(
                task: tasks[index],
                onDelete: () => deleteTask(tasks[index]),
              );
            },
          );
  }
}

// ================= TASK CARD ===================

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({super.key, required this.task, required this.onDelete});

  Color _priorityColor(String p) {
    switch (p) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade700),),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(task.priority,
                        style: TextStyle(
                            color: _priorityColor(task.priority),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(DateFormat("dd/MM/yyyy").format(task.dueDate),style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold),),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

// ================= TASK ADDITION SCREEN ===================

class TaskAdditionScreen extends StatefulWidget {
  final Function(Task) addTask;

  const TaskAdditionScreen({super.key, required this.addTask});

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

                    widget.addTask(Task(
                      title: _titleCtrl.text,
                      description: _descCtrl.text,
                      priority: _priority!,
                      dueDate: _date!,
                    ));

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

// ================= COMMUNITY PAGE ===================

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Group Task Coming Soon",
            style: TextStyle(fontSize: 18, color: Colors.black54)));
  }
}

// ================= SETTINGS PAGE ===================

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Settings Coming Soon",
            style: TextStyle(fontSize: 18, color: Colors.black54)));
  }
}
