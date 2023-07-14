import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/message.dart';

class MsgApi {
  static Future<List<ChatHistory>> fetchMsgs(String iid) async {
    print('fetching all messages');

    String backHost = dotenv.get("SERVER_HOST", fallback: "");

    final url = backHost + "/chat/history/$iid";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    //print(response.body);
    final json = jsonDecode(response.body) as List<dynamic>;
    final msgs = json.map((e) {
      return ChatHistory(
          id: e['id'],
          sender_name: e['sender_name'],
          message: e['message'],
          date_msg: e['date_msg'],
          pub_id: e['pub_id'],
          user_id: e['user_id']);
    }).toList();
    return msgs;
  }
}
