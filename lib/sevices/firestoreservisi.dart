// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/models/gonderi.dart';
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

    Future<int> takipciSayisi(kullaniciId)async{
      QuerySnapshot snapshot = await _firestore.collection("takipciler").document(kullaniciId).collection("kullaniciTakipcileri").getDocuments();
      return snapshot.documents.length;
    }

    Future<int> takipEdilenSayisi(kullaniciId)async{
      QuerySnapshot snapshot = await _firestore.collection("takipedilenler").document(kullaniciId).collection("kullaniciTakipleri").getDocuments();
      return snapshot.documents.length;
    }

    Future<void> gonderiOlustur({gonderiResimUrl,aciklama,yayinlayanId,konum})async{
      await _firestore.collection("gonderiler").document(yayinlayanId).collection("kullaniciGonderileri").add({
        "gonderiResmiUrl": gonderiResimUrl,
        "aciklama": aciklama,
        "yayinlayanId":yayinlayanId,
        "begeniSayisi":0,
        "konum":konum,
        "olusturulmaZamani":zaman

      });

    }

    Future<List<Gonderi>> gonderileriGetir(kullaniciId)async{
      QuerySnapshot snapshot =  await _firestore.collection("gonderiler").document(kullaniciId).collection("kullaniciGonderileri").orderBy("olusturulmaZamani",descending: true).getDocuments();
      List<Gonderi> gonderiler =  snapshot.documents.map((doc) => Gonderi.dokumandanUret(doc)).toList();
      return gonderiler;
    }
}