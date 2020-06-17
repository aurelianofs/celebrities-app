import 'package:celebrities/models/Socket.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  String _name = '';
  String id;
  Socket socket;

  User(this.socket) {
    socket.when('PLAYER_LOGGED', updateUser);
  }

  String get name => _name;

  set name (String value) {
    _name = value;

    socket.send("PLAYER_NAME", { "name": value });

    notifyListeners();
  }

  void updateUser(Map data) {
    id = data['id'];

    notifyListeners();
  }
}