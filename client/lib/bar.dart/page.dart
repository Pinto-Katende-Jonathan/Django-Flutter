import 'package:flutter/material.dart';
import 'package:safari/bar.dart/decon.dart';

class page extends StatefulWidget {
  const page({super.key});

  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Safari teke teke"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => decon()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),

        body: Stack(children: <Widget>[
            Container(
            decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/images/m.jpg"),
      fit: BoxFit.cover,
    ),
    ),
    ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Bienvenue à vous cher chauffeur",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ])
        ]));
  }
}
