class ChatHistory {
  final int id;
  final String message;
  final String date_msg;
  final String sender_name;
  final int pub_id;
  final int user_id;

  ChatHistory(
      {required this.id,
      required this.sender_name,
      required this.message,
      required this.date_msg,
      required this.pub_id,
      required this.user_id});
}
