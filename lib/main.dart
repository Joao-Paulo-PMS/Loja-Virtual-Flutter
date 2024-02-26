import 'package:flutter/material.dart';
import 'package:loja_virtual_b/views/Anuncios.dart';
import 'package:loja_virtual_b/views/home.dart';
import 'dart:async';
import 'package:loja_virtual_b/views/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual_b/RouteGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_b/views/Login.dart';
import 'package:loja_virtual_b/views/MeusAnuncios.dart';
import 'package:loja_virtual_b/views/NovoAnuncio.dart';


final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff9c27b0)

);

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MaterialApp(
      title: "Loja virtual",
      home: Anuncios(),
      theme: temaPadrao,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,

    ));
    child: Image.asset(
      "imagens/bicicleta.jpg",
      fit: BoxFit.fitWidth,
    );
    child: Image.asset(
      "imagens/carro.jpg.jpg",
      fit: BoxFit.fitWidth,
    );
    child: Image.asset(
      "imagens/tv.jpg",
      fit: BoxFit.fitWidth,
    );
}
//  Image.asset('imagens/bicicleta.jpg');
//  Image.asset('imagens/carro.jpg');
//Image.asset('imagens/tv.jpg');
/*
      * contain, cover, fill, fitHeight,
      * fitWidth, none, scaleDown
      * */