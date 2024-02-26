import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_b/views/widgets/ItemAnuncio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Anuncio.dart';
class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

  String? _idUsuarioLogado;
  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await  FirebaseAuth.instance.currentUser;

    _idUsuarioLogado = usuarioLogado!.uid;

  }

 // Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
 //
 //   await _recuperaDadosUsuarioLogado();
//
 //
 //   FirebaseFirestore db = FirebaseFirestore.instance;
 //   Stream<QuerySnapshot> stream = db
 //       .collection("meus_anuncios")
 //       .doc( _idUsuarioLogado )
 //       .collection("anuncios")
 //       .snapshots();
 //
 //   stream.listen((dados){
 //     _controller.add( dados );
 //   });
 // }
  _removerAnuncio(String idAnuncio){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
        .doc( _idUsuarioLogado )
        .collection("anuncios")
        .doc( idAnuncio )
        .delete().then((_){

      db.collection("anuncios")
          .doc(idAnuncio)
          .delete();

    });

  }

  @override
  void initState() {
    super.initState();
   // _adicionarListenerAnuncios();
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
        title: Text("Meus Anúncios"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("Adicionar"),
        //child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, "/novo-anuncio");
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){

          switch( snapshot.connectionState ){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:

            //Exibe mensagem de erro
              if(snapshot.hasError)
                return Text("Erro ao carregar os dados!");

              QuerySnapshot? querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot!.docs.length,
                  itemBuilder: (_, indice){

                    List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[indice];
                    Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                    return ItemAnuncio(
                      anuncio: anuncio,
                      onPressedRemover: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("Deseja realmente excluir o anúncio?"),
                                actions: <Widget>[

                                  ElevatedButton(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                  ElevatedButton(

                                    child: Text(
                                      "Remover",
                                      style: TextStyle(
                                          color: Colors.grey
                                      ),
                                    ),
                                    onPressed: (){
                                      _removerAnuncio( anuncio.id );
                                      Navigator.of(context).pop();
                                    },
                                  ),


                                ],
                              );
                            }
                        );
                      }, onTapItem: () {  },
                    );
                  }
              );

          }

          return Container();

        },
      ),
    );
  }


}
