import 'dart:convert';
import 'dart:async';
import 'package:safari/bar.dart/bar.dart';
import 'package:flutter/material.dart';
import 'package:safari/screens/publication/search.dart';
import 'package:safari/screens/user/signChoice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:safari/services/messageFlash.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 88, 223, 156), // Couleur bleu Facebook
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 200.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/carr.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(32.0, 200.0, 32.0, 16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 24.0,
                ),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom d'utilisateur",
                    prefixIcon: Icon(Icons.person),
                    hintText: "Exemple:Jean",
                    hintStyle: (TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Mots de passe",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    hintText: "*************",
                    hintStyle: (TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // foreground
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                    onPressed: loginData,
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFFFFFFFF), // Couleur bleu Facebook
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignChoice()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Vous n\'avez pas de compte ?',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(" Créez un compte.",
                            style: TextStyle(color: Colors.deepOrange)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginData() async {
    String backHost = dotenv.get("SERVER_HOST", fallback: "");
    print(backHost);
    // Get data from form
    final username = _usernameController.text;
    final password = _passwordController.text;
    final body = {"username": username.toLowerCase(), "password": password};
    // final url = backHost + "/api/login/";
    final url = backHost + "/api/login/";
    print(url);

    final uri = Uri.parse(url);

    // Submit data to the server
    final resp = await http.post(uri,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});

    // Localstorage
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (resp.statusCode == 200) {
      _usernameController.text = "";
      _passwordController.text = "";
      var parse = jsonDecode(resp.body);

      // Stock la variable token dans le localStorage
      await prefs.setString('token', parse['access']);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(parse['access']);
      await prefs.setInt('user_id_connect', decodedToken['user_id']);

      await prefs.setString('role', parse['user']['role']);
      await prefs.setString('name', parse['user']['username']);

      var role = prefs.getString('role');

      // précédente par le boutton de retour
      role == 'client'
          ?
          /*Ici l'utilisateur n'a pas la possibilté de retourner à la page
      précédente*/
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Search()),
              (route) => false,
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => bar(),
              ));
    } else {
      MessageService.showMessage(
          context, "Nom d'utilisateur ou mot de passe incorrecte", "error");
    }
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
