import 'package:flutter/material.dart';

class MessageService {
  static Future<void> showMessage(
      BuildContext context, String message, String type) async {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: type == "error" ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
