import 'package:safari/model/user.dart';

class Publication{
  final int id;
  final String depart;
  final String destination;
  final String date_voyage;
  final User user;

  Publication({
    required this.id,
    required this.depart,
    required this.destination,
    required this.date_voyage,
    required this.user,
});
}
