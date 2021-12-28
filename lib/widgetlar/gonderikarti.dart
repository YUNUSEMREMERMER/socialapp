// @dart=2.9

import 'package:flutter/material.dart';

class Gonderikarti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          _gonderiBasligi(),
          _gonderiResmi(context)
        ],
      ),
    );
  }

  Widget _gonderiBasligi() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
      ),
      title: Text(
        "Kullanıcı adı",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: null,
      ),
    );
  }

  Widget _gonderiResmi(BuildContext context) {
    return Image.network(
      "https://i4.hurimg.com/i/hurriyet/75/750x422/5c04d6230f25441c9041275b.jpg",
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
      );

  }
}
