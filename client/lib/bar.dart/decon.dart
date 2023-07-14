import 'dart:io';

import 'package:flutter/material.dart';

class decon extends StatefulWidget {
  const decon({super.key});

  @override
  State<decon> createState() => _deconState();
}

class _deconState extends State<decon> {
  void closeAppUsingExit() {
    exit(0);
  }

  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  String selected = "Raison personnelle";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pourquoi vous nous quitter?",
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    //to avoid overflow
                    child: Column(children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: DropdownButtonFormField(
                          items: const [
                            DropdownMenuItem(
                                value: 'Raison personnelle',
                                child: Text("Raison Personnelle")),
                            DropdownMenuItem(
                                value: 'bug',
                                child: Text("Il y a beaucoup des bugs")),
                          ],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          value: selected, //initial value
                          onChanged: (value) {
                            setState(() {
                              selected = value!;
                            });
                          })),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          closeAppUsingExit();
                        },
                        child: const Text("Confirmer")),
                  ),
                ])))));
  }
}
