import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Detect swipe left (negative velocity)
        if (details.primaryVelocity! < 0) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // Logo
              Image.asset(
                'assets/logo.png', // Replace with your logo path
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              // Title
              Text(
                'Code Général des Impôts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                '2025',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20),
              // Swipe Instruction
              Icon(Icons.swipe_left, size: 30, color: Colors.teal),
              Text(
                "Glissez vers la gauche pour continuer",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Spacer(),
              // Footer Section
              Column(
                children: [
                  // Company Logo/Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/company_logo.png', // Replace with your company logo path
                        height: 180,
                        width: 220,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Grow Capital Advisory',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Copyright Text
                  Text(
                    '© 2025 Grow Capital Advisory\nAll Rights Reserved',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
