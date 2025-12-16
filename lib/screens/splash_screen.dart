import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Dismissible(
        // Key is required for Dismissible
        key: const Key('splash_screen_dismissible_key'),
        // Only allow swiping from right to left (End to Start)
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (mounted && direction == DismissDirection.endToStart) {
            // Navigate to Login immediately after swipe
            Future.microtask(() {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          }
        },
        // The background visible when swiping
        background: Container(
          color: Colors.white,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ),
        // The main content of the splash screen
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Ink.image(
                image: const AssetImage('assets/logo.png'),
                height: 200,
                onImageError: (exception, stackTrace) {
                  // Handle missing image gracefully if needed
                },
              ),

              // App Title "EASY TASK"
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

              // Tagline
              Transform.translate(
                offset: const Offset(0, -20),
                child: Text("You won't be late anymore",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),

              // Swipe instruction
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