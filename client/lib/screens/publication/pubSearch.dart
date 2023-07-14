import 'package:safari/screens/publication/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/publications.dart';
import '../../model/user.dart';
import '../../services/messageFlash.dart';
import '../../services/pub_api.dart';
import '../chat/chat.dart';
import '../user/profile.dart';
import 'newPub.dart';
import 'package:http/http.dart' as http;

class PubSearch extends StatefulWidget {
  final String destination;
  final String depart;

  const PubSearch({Key? key, required this.destination, required this.depart})
      : super(key: key);

  @override
  State<PubSearch> createState() => _PubSearchState();
}

class _PubSearchState extends State<PubSearch> {
  List<Publication> pubs = [];
  var role;
  var sup;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPubSearch(widget.depart, widget.destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Publications'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            // Navigate to the Search Screen
            IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Search())),
                icon: const Icon(Icons.search))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var role = prefs.getString("role");
            var name = prefs.getString("name");

            if (role != 'client' || name == 'admin') {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NewPub()));
            } else {
              MessageService.showMessage(
                  context,
                  "Vous n'êtes pas autorisé de publier en tant que client",
                  'error');
            }
          },
          child: const Icon(Icons.add),
        ),
        body: Visibility(
          visible: isLoading,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.builder(
              itemCount: pubs.length,
              itemBuilder: (context, index) {
                final pub = pubs[index];
                final id = pub.id;
                final depart = pub.depart;
                final destination = pub.destination;
                var userId = pub.user.id;
                String username = pub.user.username;
                String photo = pub.user.photo_voiture;
                User user = pub.user;
                var dateApi = pub.date_voyage;
                DateTime datePub = DateTime.parse(dateApi);
                String formattedDate = DateFormat('dd/MM/yyyy').format(datePub);

                String backHost = dotenv.get("SERVER_HOST", fallback: "");

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/jk.jpg',
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.black.withOpacity(0.5),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  username: user.username,
                                                  email: user.email,
                                                  role: user.role,
                                                  telephone: user.telephone,
                                                  genre: user.genre,
                                                  plaque: user.plaque,
                                                  typeVoiture:
                                                      user.type_voiture,
                                                  photoVoiture:
                                                      backHost + "$photo",
                                                )),
                                      );
                                    },
                                    child: ClipOval(
                                      child: Image.network(
                                        backHost + "$photo",
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return const CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 20,
                                            child: Icon(Icons.person,
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          sup == userId
                              ? Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () {
                                      deletePubById('$id');
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date voyage : $formattedDate',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: [
                                Text(
                                  'Destination : $destination',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Depart : $depart',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    disabledForegroundColor:
                                        Colors.red.withOpacity(0.38),
                                    disabledBackgroundColor:
                                        Colors.red.withOpacity(0.12)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              MyHomePage(
                                                  senderId: '$userId',
                                                  receiverId: '$id',
                                                  pubId: '$id',
                                                  pubUser: '$userId')));
                                },
                                label: const Text(''),
                                icon: const Icon(
                                  Icons.send,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }

  Future<void> fetchPubSearch(String depart, String destination) async {
    final resp =
        await PubApi.fetchPubSearch(destination: destination, depart: depart);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userConnected = pref.getInt("user_id_connect");

    setState(() {
      pubs = resp;
      sup = userConnected;
    });

    setState(() {
      isLoading = true;
    });
  }

  Future<void> deletePubById(String id) async {
    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    final url = backHost + "/publication/delete/$id";
    // final url = 'https://web-production-c856.up.railway.app/publication/delete/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      fetchPubSearch(widget.depart, widget.destination);
      MessageService.showMessage(
          context, "Supprission avec succès \nActualisez la page", '');
    } else {
      MessageService.showMessage(context, "Erreur de suppression", 'error');
    }
  }
}
