import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual_b/main.dart';
import 'package:loja_virtual_b/views/NovoAnuncio.dart';
import 'package:loja_virtual_b/views/widgets/ItemAnuncio.dart';

import '../models/Anuncio.dart';
import '../util/Configuraçoes.dart';
class Anuncios extends StatefulWidget {
  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {

  List<String> itensMenu = [];
  late List<DropdownMenuItem<String>> _listaItensDropCategorias;
  late List<DropdownMenuItem<String>> _listaItensDropEstados;
  final _controler = StreamController<QuerySnapshot>.broadcast();
   String? _itemSelecionadoEstado;
   String? _itemSelecionadoCategoria;

  var builder;

  _escolhaMenuItem(String itemEscolhido){

    switch( itemEscolhido ){

      case "Meus anúncios" :
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar" :
        Navigator.pushNamed(context, "/login");
        break;
      case "Novo Anuncio":
        Navigator.pushNamed(context, "/novo-anuncio");
        break;


      case "Deslogar" :
        _deslogarUsuario();
        break;

    }

  }

  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushNamed(context, "/login");

  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        itensMenu = [
          "Entrar / Cadastrar"
        ];
        itensMenu = [
          "Meus anúncios", "Deslogar"
        ];
      }else{
        itensMenu = [
          "Meus anúncios", "Deslogar"
        ];
      }
    });
  }
  carregarItensDropdown(){

    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();

  }
  Future<StreamSubscription<QuerySnapshot<Object?>>> _adicionarListenerAnuncios() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    return stream.listen((dados){
      _controler.add(dados);
    });

  }
  Future<StreamSubscription<QuerySnapshot<Object?>>> _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");

    if (_itemSelecionadoEstado != null) {
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }
    if (_itemSelecionadoCategoria != null) {
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    return stream.listen((dados) {
      _controler.add(dados);
    });

  }
  @override
  void initState() {
    super.initState();
    carregarItensDropdown();
    _verificarUsuarioLogado();
    _adicionarListenerAnuncios();
    _filtrarAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[

        Text("Carregando anúncios"),
        CircularProgressIndicator()

      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Loja Virtual"),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[

          Row(children: <Widget>[

            Expanded(
              child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: temaPadrao.primaryColor,
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black
                      ),
                      onChanged: (estado){
                        setState(() {
                          _itemSelecionadoEstado = estado!;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  )
              ),
            ),

            Container(
              color: Colors.grey[200],
              width: 2,
              height: 60,
            ),

            Expanded(
              child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: Color(0xff9c27b0),
                      value: _itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black
                      ),
                      onChanged: (categoria){
                        setState(() {
                          _itemSelecionadoCategoria = categoria!;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  )
              ),
            )



          ],),
          StreamBuilder(
            stream: _controler.stream,
            builder: (context, snapshot){
              switch( snapshot.connectionState ){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return carregandoDados;
                  break;
                case ConnectionState.active:
                case ConnectionState.done:

                  QuerySnapshot<Object?>? querySnapshot = snapshot.data;

                  if( querySnapshot!.docs.length == 0 ){
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Text("Nenhum anúncio! :( ", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, indice){

                          List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = anuncios[indice];
                          Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                          return ItemAnuncio(
                            anuncio: anuncio,
                            onTapItem: (){
                              Navigator.pushNamed(
                                  context,
                                  "/detalhes-anuncio",
                                  arguments: anuncio
                              );
                            }, onPressedRemover: () {  },
                          );

                        }
                    ),
                  );

              }
              return Container();
            },
          )

        ],),
      ),
    );
  }
}
