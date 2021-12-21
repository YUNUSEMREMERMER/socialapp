// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/models/kullanici.dart';
import 'package:socialapp/pages/anasayfa.dart';
import 'package:socialapp/pages/girissayfasi.dart';
import 'package:socialapp/sevices/yetkilendirmeservisi.dart';

class Yonlendirme extends StatelessWidget {
  
  

  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context,listen:false);

    return StreamBuilder(
      stream: _yetkilendirmeServisi.durumTakipcisi,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        if(snapshot.hasData){
          Kullanici aktifKullanici = snapshot.data;
          return Anasayfa();
        }else{
          return GirisSayfasi();
        }
      },
      
    );
  }
}