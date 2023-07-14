import 'package:safari/bar.dart/decon.dart';
import 'package:safari/screens/publication/pubSearch.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _departController = TextEditingController();

  @override
  void dispose() {
    _destinationController.dispose();
    _departController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche une publication"),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Svp préciser la destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departController,
                decoration: const InputDecoration(labelText: 'Depart'),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Svp précisez le départ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //fetchPubSearch(_departController.text, _destinationController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PubSearch(
                                    destination: _destinationController.text,
                                    depart: _departController.text,
                                  )));
                    }
                  },
                  child: const Text('Rechercher'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
