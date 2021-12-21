// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/models/kullanici.dart';

class FireStoreServisi{
    final Firestore _firestore = Firestore.instance;
    final DateTime zaman = DateTime.now();

    kullaniciOlustur({id,email,kullaniciAdi,fotoUrl=""})async{
      await _firestore..collection("kullanicilar").document(id).setData({
        "kullaniciAdi":kullaniciAdi,
        "email":email,
        "fotoUrl":fotoUrl,
        "hakkinda":"",
        "olusturulmaZamani":zaman
      }
        
      );
    }

    Future<Kullanici> kullaniciGetir(id)async{
      DocumentSnapshot doc = await _firestore.collection("kullanicilar").document(id).get();
      if(doc.exists){
        Kullanici kullanici = Kullanici.dokumandanUret(doc);
        return kullanici;
      }
      return null;
    }
}