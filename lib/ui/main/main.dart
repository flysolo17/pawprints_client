import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/img/paw_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Pawprints',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001B44),
              ),
            ),
            const Text(
              "Aucena Veterinary Clinic",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                context.go('/login');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF001B44),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.pets,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Tap to Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
