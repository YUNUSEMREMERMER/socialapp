import 'package:flutter/material.dart';

class Yukle extends StatefulWidget {
  const Yukle({ Key? key }) : super(key: key);

  @override
  _YukleState createState() => _YukleState();
}

class _YukleState extends State<Yukle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "yukleme sayfası"
      ),
    );
  }
}