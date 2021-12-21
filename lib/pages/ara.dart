import 'package:flutter/material.dart';

class Ara extends StatefulWidget {
  const Ara({ Key? key }) : super(key: key);

  @override
  _AraState createState() => _AraState();
}

class _AraState extends State<Ara> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Arama sayfası"
      ),
    );
  }
}