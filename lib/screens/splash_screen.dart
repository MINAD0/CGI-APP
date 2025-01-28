import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/main');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(), // Push the content to the center
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
            Spacer(), // Push the footer to the bottom
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(width: 8),
                  Text(
                    'Grow Capital Advisory',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ]),
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
    );
  }
}
