import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final String role;
  final String? telephone;
  final String genre;
  final String? plaque;
  final String? typeVoiture;
  final String photoVoiture;

  const ProfilePage({
    Key? key,
    required this.username,
    required this.email,
    required this.role,
    this.telephone,
    required this.genre,
    this.plaque,
    this.typeVoiture,
    required this.photoVoiture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$username Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueAccent, Colors.lightBlue],
                ),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoVoiture),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              username.toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'INFORMATIONS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.person_outline, color: Colors.grey),
                        Text(
                          role,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.wc_outlined, color: Colors.grey),
                        Text(
                          genre,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (telephone != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.phone_android_outlined, color: Colors.grey),
                          Text(
                            telephone!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                    if (plaque != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.confirmation_number_outlined, color: Colors.grey),
                          Text(
                            plaque!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                    if (typeVoiture != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.car_rental_outlined, color: Colors.grey),
                          Text(
                            typeVoiture!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
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
