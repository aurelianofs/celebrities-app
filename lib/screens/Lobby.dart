import 'package:celebrities/models/Socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:celebrities/models/GamesList.dart';

class Lobby extends StatelessWidget {
  final Socket socket;

  Lobby(this.socket);

  @override
  Widget build(BuildContext context) {
    final gamesList = Provider.of<GamesList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: gamesList.games.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return gamesList.games.length > index ?
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("${gamesList.games[index].host}'s Game")),
                  RaisedButton(
                    onPressed: (){
                      socket.send("JOIN_GAME", { "id": gamesList.games[index].id });
                    },
                    child: Text('Join This Game'),
                  )
                ]
              ),
            ) :
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: RaisedButton(
                onPressed: (){
                  socket.send("CREATE_GAME");
                },
                child: Text('Create New Game'),
              )
            );
          }
        )
      )
    );
  }
}