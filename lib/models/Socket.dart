import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Socket {
  String url;
  var channel;
  Map suscriptions = {};

  Socket(this.url) {
    channel = IOWebSocketChannel.connect(url);

    channel.stream.listen((jsonMsg) {
      Map msg = jsonDecode(jsonMsg);

      if(suscriptions[msg["action"]] != null) {
        suscriptions[msg["action"]].forEach((Function fn) {
          fn(msg["data"]);
        });
      }
    });

    send("PLAYER_LOGIN", { "id": null });
  }

  void send(String action, [ Map data ]) {

    channel.sink.add(json.encode({
      "action": action,
      "data": data
    }));
  }

  void when(String action, Function(Map) fn) {
    if(suscriptions[action] == null) {
      suscriptions[action] = List<Function>();
    }

    suscriptions[action].add(fn);
  }
}