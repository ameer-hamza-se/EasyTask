import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;

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
                        children: [
                          Ink.image(
                            image: const AssetImage('assets/logo.png'),
                            height: 160,
                            width: 160,
                            onImageError: (exception, stackTrace) {},
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

                      setState(() {
                        emailError = null;
                        passwordError = null;
                        generalError = null;
                      });

                      if (email.isEmpty || password.isEmpty) {
                        setState(() {
                          if (email.isEmpty) emailError = "Username is required";
                          if (password.isEmpty) passwordError = "Password is required";
                        });
                        return;
                      }

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
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