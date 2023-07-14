import 'package:safari/model/publications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:safari/model/user.dart';


class PubApi {
  static Future<List<Publication>> fetchPubs() async {
    print('fetching all pubs');

    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    final url =backHost + "/publications/";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as List<dynamic>;
    final pubs = json.map((e) {
/*      final user = User(
          id: e['user']['id'],
          username: e['user']['username'],
          email: e['user']['email'],
          role: e['user']['role'],
          telephone: e['user']['telephone'],
          genre: e['user']['genre'],
          plaque: e['user']['plaque'],
          type_voiture: e['user']['type_voiture'],
          photo_voiture: e['user']['photo_voiture']);
*/
      final user = User(
          id: e['user']['id'] ?? 0,
          username: e['user']['username'] ?? '',
          email: e['user']['email'] ?? '',
          role: e['user']['role'] ?? '',
          telephone: e['user']['telephone'] ?? '',
          genre: e['user']['genre'] ?? '',
          plaque: e['user']['plaque'] ?? '',
          type_voiture: e['user']['type_voiture'] ?? '',
          photo_voiture: e['user']['photo_voiture'] ?? '');
      return Publication(
          id: e['id'],
          depart: e['depart'],
          destination: e['destination'],
          date_voyage: e['date_voyage'],
          user: user);
    }).toList();
    return pubs;
  }

  static Future<List<Publication>> fetchPubSearch(
      {required String depart, required String destination}) async {

    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    print('fetching all pubs from search');
    final url = backHost + "/pub/spec?destination=$destination&&depart=$depart";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as List<dynamic>;
    print(json);
    final pubs = json.map((e) {

      final user = User(
          id: e['user']['id'] ?? 0,
          username: e['user']['username'] ?? '',
          email: e['user']['email'] ?? '',
          role: e['user']['role'] ?? '',
          telephone: e['user']['telephone'] ?? '',
          genre: e['user']['genre'] ?? '',
          plaque: e['user']['plaque'] ?? '',
          type_voiture: e['user']['type_voiture'] ?? '',
          photo_voiture: e['user']['photo_voiture'] ?? '');
      return Publication(
          id: e['id'],
          depart: e['depart'],
          destination: e['destination'],
          date_voyage: e['date_voyage'],
          user: user);
    }).toList();
    return pubs;
  }
}
