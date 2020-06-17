// MODELS
import 'package:celebrities/models/Socket.dart';
import 'package:celebrities/models/User.dart';
import 'package:celebrities/models/GamesList.dart';
import 'package:celebrities/models/Game.dart';

// SCREENS
import 'package:celebrities/screens/Welcome.dart';
import 'package:celebrities/screens/Lobby.dart';
import 'package:celebrities/screens/Room.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final socket = Socket('ws://localhost:8080');

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User(socket)),
        ChangeNotifierProvider(create: (context) => GamesList(socket)),
        ChangeNotifierProvider(create: (context) => Game(socket)),
      ],
      child: MaterialApp(
        title: 'Celebrities',
        home: Consumer2<User, Game> (
          builder: (context, user, game, child) {
            return user.name == null || user.name.isEmpty ?
              Welcome() :
              game.id == null ? Lobby(socket) :
              Room(socket);
          }
        )
      )
    );
  }
}