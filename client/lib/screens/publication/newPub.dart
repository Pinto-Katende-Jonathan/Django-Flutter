import 'dart:convert';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safari/services/messageFlash.dart';

class NewPub extends StatefulWidget {
  const NewPub({Key? key}) : super(key: key);

  @override
  _NewPubState createState() => _NewPubState();
}

class _NewPubState extends State<NewPub> {
  //Permet de controller le formulaire
  final _formKey = GlobalKey<FormState>();

  final departController = TextEditingController();
  final destinationController = TextEditingController();
  DateTime date_depart = DateTime.now();

  //Quand l'application se minimalise et qu'on a besoin de memoire,
  // on utilise dispose
  @override
  void dispose() {
    super.dispose();
    departController.dispose();
    destinationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle publication'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Depart',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vous devez compléter ce champ';
                          }
                          return null;
                        },
                        controller: departController,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Destination',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vous devez compléter ce champ';
                          }
                          return null;
                        },
                        controller: destinationController,
                      ),
                      const SizedBox(height: 10),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: 'Choisir la date de départ',
                        ),
                        mode: DateTimeFieldPickerMode.dateAndTime,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1
                            ? 'Please not the first day'
                            : null,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            date_depart = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              
                Center(
                  child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 500, height: 200),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          pubData();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Envoi en cours")));
                        }
                        //Fermer le clavier lors de la soumission
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 79, 125, 205),
                        elevation: 3,
                        padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Créer la publication',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                
                )),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- Form submition -------------------------
  Future<void> pubData() async {
    // Get data from form
    final depart = departController.text;
    final destination = destinationController.text;

    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    //Url
    final url = backHost + "/publication/create/";
    // final url = 'https://web-production-c856.up.railway.app/publication/create/';
    final uri = Uri.parse(url);

    //Récupération du userId à partir du localStorage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userConnected = prefs.getInt("user_id_connect");

    final body = {
      "depart": depart,
      "destination": destination,
      "date_voyage": '$date_depart',
      "user_id": userConnected
    };

    // Submit data to the server
    final resp = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    // Show success Message or Fail Message, based on status
    if (resp.statusCode == 200) {
      MessageService.showMessage(context, "Créée avec succès", "success");
      destinationController.text = "";
      departController.text = "";

      setState(() {
        date_depart = DateTime.now();
      });
    } else {
      MessageService.showMessage(context, resp.body, "error");
    }
    print(resp.body);
  }
}
