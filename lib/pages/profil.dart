// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/models/gonderi.dart';
import 'package:socialapp/models/kullanici.dart';
import 'package:socialapp/sevices/firestoreservisi.dart';
import 'package:socialapp/sevices/yetkilendirmeservisi.dart';
import 'package:socialapp/widgetlar/gonderikarti.dart';

class Profil extends StatefulWidget {
  final String profilsahibiId;

  const Profil({Key key, this.profilsahibiId}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderiSayisi = 0;
  int _takipci = 0;
  int _takipEdilen = 0;
  List<Gonderi> _gonderiler = [];
  String gonderiStili = "liste";

  _takipciSayisiGetir() async {
    int takipciSayisi =
        await FireStoreServisi().takipciSayisi(widget.profilsahibiId);
    setState(() {
      _takipci = takipciSayisi;
    });
  }

  _takipEdilenSayisiGetir() async {
    int takipEdilenSayisi =
        await FireStoreServisi().takipEdilenSayisi(widget.profilsahibiId);
    setState(() {
      _takipEdilen = takipEdilenSayisi;
    });
  }

  _gonderileriGetir() async {
    List<Gonderi> gonderiler =
        await FireStoreServisi().gonderileriGetir(widget.profilsahibiId);
    setState(() {
      _gonderiler = gonderiler;
      _gonderiSayisi = _gonderiler.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
    _gonderileriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        actions: <Widget>[
          IconButton(
            onPressed: _cikisYap,
            icon: Icon(Icons.exit_to_app),
            color: Colors.black,
          )
        ],
      ),
      body: FutureBuilder<Object>(
          future: FireStoreServisi().kullaniciGetir(widget.profilsahibiId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: [_profilDetaylari(snapshot.data), _gonderileriGoster()],
            );
          }),
    );
  }

  Widget _gonderileriGoster() {
    if (gonderiStili == "liste") {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _gonderiler.length,
        itemBuilder: (context, index) {
          return Gonderikarti();
        },
      );
    } else {
      List<GridTile> fayanslar = [];
      _gonderiler.forEach((gonderi) {
        fayanslar.add(_fayansOlustur(gonderi));
      });

      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
        children: fayanslar,
      );
    }
  }

  GridTile _fayansOlustur(Gonderi gonderi) {
    return GridTile(
      child: Image.network(
        gonderi.gonderiResmiUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _profilDetaylari(Kullanici profilData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                backgroundImage: profilData.fotoUrl.isNotEmpty
                    ? NetworkImage(profilData.fotoUrl)
                    : AssetImage("assets/images/balik.jpg"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sosyalSayac("G??nderiler", _gonderiSayisi),
                    _sosyalSayac("Takip??i", _takipci),
                    _sosyalSayac("Takip", _takipEdilen),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profilData.kullaniciAdi,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(profilData.hakkinda),
          SizedBox(
            height: 25.0,
          ),
          _profiliDuzenleButton(),
        ],
      ),
    );
  }

  Widget _profiliDuzenleButton() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {},
        child: Text("Profili D??zenle"),
      ),
    );
  }

  Widget _sosyalSayac(String baslik, int sayi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          sayi.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          baslik,
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }

  void _cikisYap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}
