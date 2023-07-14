import 'package:flutter/material.dart';

import 'chauffeur.dart';
import 'client.dart';

class SignChoice extends StatefulWidget {
  const SignChoice({Key? key}) : super(key: key);

  @override
  State<SignChoice> createState() => _SignChoiceState();
}

class _SignChoiceState extends State<SignChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(

                backgroundColor: Colors.blue, // foreground
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => const ClientSign()));
              },
              child: const Text(
                'Client',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // foreground
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: () {
                Navigator.push(context,
                PageRouteBuilder(pageBuilder: (_, __, ___) => const ChauffeurSign()));
              },
              child: const Text(
                'Chauffeur',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}