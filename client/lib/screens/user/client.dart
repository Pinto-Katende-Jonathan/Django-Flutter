import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../services/messageFlash.dart';

class ClientSign extends StatefulWidget {
  const ClientSign({Key? key}) : super(key: key);

  @override
  State<ClientSign> createState() => _ClientSignState();
}

class _ClientSignState extends State<ClientSign> {
  File? imageFile;
  var _hidePassword = true;

  final _formKey = GlobalKey<FormState>();

  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedSexe = "feminin";

  @override
  void dispose() {
    super.dispose();
    nomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // let us to avoid overflow bottom
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Formulaire Client'),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                //to avoid overflow
                child: Column(
              children: [
                TextFormField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Noms',
                    hintText: 'Entre ton nom complet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vous devez remplir ce champs";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Entre ton Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vous devez remplir ce champs";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: telephoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telephone',
                    hintText: 'Entre ton numero de telephone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vous devez remplir ce champs";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(
                            value: 'masculin', child: Text("Masculin")),
                        DropdownMenuItem(
                            value: 'feminin', child: Text("Féminin")),
                      ],
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      value: selectedSexe, //initial value
                      onChanged: (value) {
                        setState(() {
                          selectedSexe = value!;
                        });
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: selectFile,
                    label: const Text('Select Image Profile'),
                    icon: const Icon(Icons.photo),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _hidePassword,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Entre ton mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vous devez remplir ce champs";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  title: const Text("Afficher le mot de passe"),
                  value: !_hidePassword,
                  // Met la checkbox à gauche
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  }, //  <-- leading Checkbox
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Soumission en cours")));
                          //Ferme le clavier après soumission
                          FocusScope.of(context).requestFocus(FocusNode());

                          signClient();
                        }
                      },
                      child: const Text("Soumettre")),
                ),
              ],
            )),
          ),
        ));
  }

  Future<void> signClient() async {
    final nom = nomController.text;
    final phone = telephoneController.text;
    final email = emailController.text;
    final password = passwordController.text;

    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    //const url = 'http://localhost:8000/api/create-user/';
    final url = backHost + "/api/create-user/";
    final uri = Uri.parse(url);

    Map<String, String> formData = {
      "username": nom.toLowerCase(),
      "telephone": phone,
      "email": email,
      "password": password,
      "genre": selectedSexe,
      "role": 'client'
    };

// Create a multipart request and add the form data and image file
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(formData);
    request.headers['Content-Type'] = 'text/plain; charset=utf-8';

    if (imageFile!.existsSync()) {
      String? filename = imageFile?.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
          'photo_voiture', imageFile!.path,
          filename: filename));
    }

// Send the multipart request and get the response
    var response = await http.Response.fromStream(await request.send());

// Decode and print the response data
    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      print(responseData);

      nomController.text = "";
      passwordController.text = "";
      telephoneController.text = "";
      emailController.text = "";

      MessageService.showMessage(
          context, "Enregistrement avec succès", "success");
    } else {
      MessageService.showMessage(context, response.body, "error");
    }
  }

  Future selectFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
