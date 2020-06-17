import 'package:celebrities/models/Socket.dart';
import 'package:flutter/foundation.dart';

class GameItem {
  int id;
  String host;

  GameItem(this.id, this.host);
}

class GamesList extends ChangeNotifier {
  List<GameItem> games;
  final Socket socket;

  GamesList(this.socket) {
    socket.when('PLAYER_LOGGED', updateGames);
    socket.when('AVAILABLE_GAMES', updateGames);
  }

  void updateGames(Map data) {
    games = new List<GameItem>();

    data['games'].forEach((g){
      games.add(new GameItem(g['id'], g['host']));
    });

    notifyListeners();
  }
}