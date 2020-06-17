import 'package:celebrities/models/Game.dart';
import 'package:celebrities/models/Socket.dart';
import 'package:celebrities/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ConnectedPlayers extends StatelessWidget {
  final List<Player> players;

  ConnectedPlayers(this.players);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: players.length + 1,
      itemBuilder: (BuildContext context, int index) {
        final Player player = index > 0 ? players[index - 1] : null;
        return Container(
          padding: const EdgeInsets.all(5.0),
          child: player == null ?
            Text(
              'Connected Players',
              style: Theme.of(context).textTheme.headline6,
            ) :
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: player.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  if(player.character != null) ...[
                    TextSpan(text: ' is '),
                    TextSpan(text: player.character, style: TextStyle(fontWeight: FontWeight.bold))
                  ]
                ],
              ),
            )
        );
      }
    );
  }
}

class Room extends StatelessWidget {
  final _controller = TextEditingController();
  final Socket socket;

  Room(this.socket);

  @override
  Widget build(BuildContext context) {
    final Game game = Provider.of<Game>(context);
    final User user = Provider.of<User>(context);

    final Player host = game.players.firstWhere((p) => p.id == game.hostId);
    final Player mePlayer = game.players.firstWhere((p) => p.id == user.id);
    final Player target = mePlayer.target != null ?
      game.players.firstWhere((p) => p.id == mePlayer.target) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("${host.name}'s Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(target != null && target.character == null) Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(labelText: 'Give ${target.name} a character')
                      )
                    ),
                    RaisedButton(
                      onPressed: (){
                        final String character = _controller.text;
                        socket.send("ASSIGN_CHARACTER", { 'character': character});
                      },
                      child: Text('Assign'),
                    )
                  ]
                ),
              ),
              ConnectedPlayers(game.players),
              Row(
                children: <Widget>[
                  if(user.id == game.hostId) Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      onPressed: (){
                        socket.send("START_GAME");
                      },
                      child: Text('Start Game'),
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      socket.send("LEAVE_GAME");
                    },
                    child: Text('Leave Game'),
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }
}