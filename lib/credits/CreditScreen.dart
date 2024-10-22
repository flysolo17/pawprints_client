import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Credits'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the card vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the card horizontally
          children: [
            // Paw print logo at the top
            const CircleAvatar(
              radius: 50, // Size of the logo
              backgroundColor: Colors.white,
              backgroundImage:
                  AssetImage('assets/paw_logo.png'), // Adjust the path of image
            ),
            const SizedBox(height: 20), // Add some spacing after the logo
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust size based on content
                  children: [
                    const Text(
                      'Credits',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCreditItem(
                      context,
                      'Garcia, Ailen B.',
                      'Adviser',
                      'assets/ailen_garcia.png', // Adjust the path of image as necessary
                    ),
                    _buildCreditItem(
                      context,
                      'Turga, Eleonor',
                      'Critic Reader',
                      'assets/eleonor_turga.png',
                    ),
                    _buildCreditItem(
                      context,
                      'Sangalang, Sherwin',
                      'Data Analyst',
                      'assets/sherwin_sangalang.png',
                    ),
                    _buildCreditItem(
                      context,
                      'Manuel, Ariel R.',
                      'Instructor',
                      'assets/ariel_manuel.png',
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

  Widget _buildCreditItem(
      BuildContext context, String name, String role, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
