import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA), // Light background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF001B44), // Dark blue AppBar
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF001B44)),
                ),
                SizedBox(width: 10),
                Text(
                  "Hello, Kim",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Handle menu button press
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pawprints Logo and Clinic Name
            Row(
              children: [
                Image.asset(
                  'lib/assets/img/paw_logo.png', // Ensure your logo is correctly placed in the assets
                  height: 40,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "PAWPRINTS",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001B44),
                      ),
                    ),
                    Text(
                      "Aucena Veterinary Clinic",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: Colors.blue[900], // Background color for banner
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "PET CARE",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'lib/assets/img/pets_banner.jpg',
                    height: 60,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "SERVICES",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF001B44),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  serviceTile("Laboratory Examinations"),
                  serviceTile("Additional Vaccines"),
                  serviceTile("Test Kits"),
                  serviceTile("Health Programs for Dogs"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF001B44),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
        ],
        onTap: (index) {},
      ),
    );
  }

  Widget serviceTile(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF001B44),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {},
    );
  }
}
