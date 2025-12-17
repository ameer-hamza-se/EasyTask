import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart'; // Import Provider

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
                        image: const AssetImage('assets/logo.png'), height: 120,
                        onImageError: (e, s) {}),
                    const SizedBox(height: 6),
                    const Text("EASY TASK",
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
              const Text("User Name (Email)"),
              const SizedBox(height: 8),
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(
                  hintText: "Enter Email",
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
                      if (fullCtrl.text.isEmpty ||
                          userCtrl.text.isEmpty ||
                          passCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please fill all fields")));
                        return;
                      }

                      try {
                        // 1. Create User
                        UserCredential userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: userCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                        );

                        // 2. Update Display Name in Firebase
                        if (userCredential.user != null) {
                          await userCredential.user!
                              .updateDisplayName(fullCtrl.text.trim());

                          // 3. Update Provider state locally
                          if (context.mounted) {
                            context.read<TaskProvider>().setUser(
                              fullCtrl.text.trim(),
                              userCtrl.text.trim(),
                            );

                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
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