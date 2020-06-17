import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:celebrities/models/User.dart';

class Welcome extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'What\'s your name?')
              ),
              RaisedButton(
                onPressed: (){
                  final user = Provider.of<User>(context);
                  user.name = _controller.text;
                },
                child: Text('Submit'),
              )
            ]
          )
        )
      )
    );
  }
}