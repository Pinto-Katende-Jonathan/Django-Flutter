import 'package:safari/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<User> fetchUser(String id) async {
    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    final url = backHost + "/api/get-user/$id";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        role: json['role'],
        telephone: json['telephone'],
        genre: json['genre'],
        plaque: json['plaque'],
        type_voiture: json['type_voiture'],
        photo_voiture: json['photo_voiture']
    );
  }
}
