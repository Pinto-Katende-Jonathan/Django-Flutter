import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../model/message.dart';
import '../../services/chatHistory.dart';

class MyHomePage extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String pubId;
  final String pubUser;

  const MyHomePage({
    required this.senderId,
    required this.receiverId,
    required this.pubId,
    required this.pubUser,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel channels;
  List<ChatHistory> chatHist = [];
  final TextEditingController _msgController = TextEditingController();
  var connUser;

  @override
  void initState() {
    super.initState();
    getmsgs(widget.pubId);
    connectAndLinstener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: chatHist.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentUser = '$connUser';
                  final message = chatHist[index];
                  // final id = message.id;
                  final description = message.message;
                  final userId = message.user_id;
                  // final pubId = message.pub_id;
                  final sender_name = message.sender_name;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      //alignment: userId == widget.senderId ? Alignment.centerLeft : Alignment.centerRight,
                      alignment: currentUser != '$userId'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: currentUser != '$userId'
                              ? Colors.white
                              : Colors.blue[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              sender_name,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(description,
                                style: TextStyle(
                                    color: currentUser != '$userId'
                                        ? Colors.black
                                        : Colors.white))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(32.0),
                border: Border.all(width: 2.0, color: Colors.blueGrey),
              ),
              child: Row(
                children: [
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: const InputDecoration(
                        hintText: 'Ecrire un message...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: sendMessageRealTime,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blueGrey),
                    onPressed: () => sendMessageRealTime(_msgController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ChatHistory msgHit(String message) {
    final json = jsonDecode(message);
    return ChatHistory(
        id: json['id'],
        sender_name: json['sender_name'],
        message: json['message'],
        date_msg: json['date_msg'],
        pub_id: json['pub_id'],
        user_id: json['user_id']);
  }

  // add and update list of ChatHistory
  void addMsg(dynamic message) {
    ChatHistory msg = msgHit(message);
    setState(() {
      chatHist.add(msg);
    });
  }

  // Connect To Socket Chat by bienfaitshm
  Future<void> connectAndLinstener() async {
    String backHost = dotenv.get("WEBSOCKET_SERVER_HOST", fallback: "");
    final pubId = widget.pubId;
    try {
      channels = WebSocketChannel.connect(Uri.parse("$backHost/chat/$pubId/"));
      channels.stream.listen(addMsg);
    } catch (exeption) {
      print("SOCKET ERROR");
      connectAndLinstener();
    }
  }

  // Get All messages for a specific Pub
  Future<void> getmsgs(String iid) async {
    final resp = await MsgApi.fetchMsgs(iid);

    SharedPreferences pref = await SharedPreferences.getInstance();
    var userConnected = pref.getInt("user_id_connect");

    setState(() {
      chatHist = resp;
      connUser = userConnected;
    });
  }

  void sendMessageRealTime(String message) async {
    final data = {
      'message': message,
      'pub_id': widget.pubId,
      'user_id': connUser,
    };
    channels.sink.add(jsonEncode(data));
    _msgController.clear();
  }

  // Send Message
  void sendMessage(String message) async {
    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    final url = backHost + "/chat/create/";
    final data = {
      'message': message,
      'pub_id': widget.pubId,
      'user_id': connUser,
    };

    final response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      print('Message sent successfully');
      getmsgs(widget.pubId);
      _msgController.clear();
    } else {
      print('Failed to send message');
    }
  }
}
