// @dart=2.9
import 'package:flutter/material.dart';
import 'package:socialapp/sevices/yetkilendirmeservisi.dart';

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () => YetkilendirmeServisi().cikisYap(),
            child: Text("Çıkış Yap")),
      ),
    );
  }
}
