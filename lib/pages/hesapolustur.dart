// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/models/kullanici.dart';
import 'package:socialapp/pages/girissayfasi.dart';
import 'package:socialapp/sevices/firestoreservisi.dart';
import 'package:socialapp/sevices/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;

  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();

  String kullaniciAdi, email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formAnahtari,
                child: Column(
                  children: [
                    TextFormField(
                      autocorrect: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Kullanıcı adınızı giriniz",
                        labelText: "Kullanıcı adı",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Kullanıcı adı boş bırakılamaz";
                        } else if (girilenDeger.trim().length < 4 ||
                            girilenDeger.trim().length > 10) {
                          return "En az 4 en fazla 10 karakter olabilir";
                        }
                      },
                      onSaved: (girilenDeger) {
                        kullaniciAdi = girilenDeger;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "mail",
                        hintText: "Email adresinizi giriniz",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.mail),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Email alanı boş bırakılamaz";
                        } else if (!girilenDeger.contains("@")) {
                          return "girilen deger mail formatında olmalı";
                        }
                      },
                      onSaved: (girilenDeger) {
                        email = girilenDeger;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "şifrenizi giriniz",
                        labelText: "Şifre",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Şifre alanı boş bırakılamaz";
                        } else if (girilenDeger.trim().length < 6) {
                          return "şifre 6 karakterden az olamaz";
                        }
                      },
                      onSaved: (girilenDeger) {
                        sifre = girilenDeger;
                      },
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                          onPressed: _kullaniciOlustur,
                          child: Text(
                            "Hesap Oluştur",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context,listen:false);
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });

      try {
        Kullanici kullanici = await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if(kullanici != null){
          FireStoreServisi().kullaniciOlustur(id: kullanici.id,email: kullanici.email,kullaniciAdi: kullanici.kullaniciAdi);
        }
        Navigator.pop(context);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hata.code);
      }
    }
  }

  uyariGoster(hatakodu) {
    String hataMesaji;
    if (hatakodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersiz";
    }
    else if (hatakodu == "ERROR_EMAIL_ALREADY_IN_USE") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    }
    else if (hatakodu == "ERROR_WEAK_PASSWORD") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
