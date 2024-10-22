import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pawprints - Aucena Veterinary Clinic'),
        backgroundColor: const Color.fromARGB(255, 17, 55, 128),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content
          children: [
            // PawPrints Logo
            Center(
              child: Image.asset(
                'lib/assets/img/paw_logo.png', // Ensure the path is correct
                height: 80, // Adjust the height as needed
              ),
            ),
            const SizedBox(height: 20), // Spacing between logo and title
            const Text(
              'Developers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily:
                    'YourFontFamily', // Change to your desired font family
              ),
              textAlign: TextAlign.center, // Center the text
            ),
            const SizedBox(height: 20),
            const DeveloperCard(
                name: 'Lumogda, Katherine V.',
                role: 'Programmer',
                imagePath: 'lib/assets/img/dev1.png'),
            const SizedBox(height: 16),
            DeveloperCard(
              name: 'Lacsao, Khristine M.',
              role: 'Documentator',
              imagePath: 'lib/assets/img/dev2.png', // Replace with actual path
            ),
            const SizedBox(height: 16),
            DeveloperCard(
              name: 'Cuello, Eugene J.',
              role: 'Researcher',
              imagePath: 'lib/assets/img/dev3.png', // Replace with actual path
            ),
            const SizedBox(height: 16),
            const DeveloperCard(
              name: 'Rea, Jocel Mae D.',
              role: 'Designer',
              imagePath: 'lib/assets/img/dev4.png', // Replace with actual path
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  const DeveloperCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  role,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
