
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Anuncio {

  late String _id;
  late String _estado;
  late String _categoria;
  late String _titulo;
  late String _preco;
  late String _telefone;
 late String _descricao;
 late List<String> _fotos;
 String? documentID;
  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){


    this.id = documentSnapshot.id;
    this.estado = documentSnapshot["estado"];
    this.categoria = documentSnapshot["categoria"];
    this.titulo     = documentSnapshot["titulo"];
    this.preco      = documentSnapshot["preco"];
    this.telefone   = documentSnapshot["telefone"];
    this.descricao  = documentSnapshot["descricao"];
    this.fotos  = List<String>.from(documentSnapshot["fotos"]);
    this.documentID = documentSnapshot.id;
    //Map<String, dynamic> data = documentSnapshot.data! as Map<String, dynamic>;
  }
 Anuncio.gerarId(){
   FirebaseFirestore db = FirebaseFirestore.instance;
   CollectionReference anuncios = db.collection("meus_anuncios");

   this.id = anuncios.doc(documentID).get as String;




   this.fotos = [];


 }

  Map<String, dynamic> toMap(){
 //  var x = {};
 //  print(x.runtimeType);
 //  Map<String, dynamic> y = Map.castFrom<dynamic, dynamic, String, dynamic>(x);
 //  print(y.runtimeType);
    Map<String, dynamic> map = {
      "id" : this.id,
      "estado" : this.estado,
      "categoria" : this.categoria,
      "titulo" : this.titulo,
      "preco" : this.preco,
      "telefone" : this.telefone,
      "descricao" : this.descricao,
      "fotos" : this.fotos,
    };

    return map;

  }


  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}

