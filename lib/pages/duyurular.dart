import 'package:flutter/material.dart';

class Duyurular extends StatefulWidget {
  const Duyurular({ Key? key }) : super(key: key);

  @override
  _DuyurularState createState() => _DuyurularState();
}

class _DuyurularState extends State<Duyurular> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "duyuru"
      ),
    );
  }
}