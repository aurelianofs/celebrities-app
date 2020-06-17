import 'package:celebrities/models/Socket.dart';
import 'package:flutter/material.dart';

class Player {
  final String id;
  final String name;
  final String target;
  final String character;

  Player(this.id, this.name, this.target, this.character);
}

class Game extends ChangeNotifier {
  final Socket socket;
  int id;
  String hostId;
  List<Player> players;

  Game(this.socket) {
    socket.when('PLAYER_LOGGED', updateGame);
    socket.when('GAME_UPDATE', updateGame);
  }

  void updateGame(Map data) {

    id = data['game'] != null ? data['game']['id'] : null;
    hostId = data['game'] != null ? data['game']['hostId'] : null;

    players = new List<Player>();

    if(data['game'] != null) {
      data['game']['players'].forEach((p){
        players.add(
          new Player(
            p['id'],
            p['name'],
            p['target'],
            p['character']
          )
        );
      });
    }

    notifyListeners();
  }
}