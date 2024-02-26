import 'dart:io';
import 'package:flutter/src/material/dropdown.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loja_virtual_b/models/Anuncio.dart';
import 'package:loja_virtual_b/views/widgets/BotaoCustomizado.dart';
import 'package:loja_virtual_b/views/widgets/InputCustomizado.dart';
import 'package:validadores/validadores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loja_virtual_b/models/Anuncio.dart';
import '../util/Configuraçoes.dart';




class NovoAnuncio extends StatefulWidget {



  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  final List<File> _listaImagens = [];

  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
   Anuncio? _anuncio;





  final _formKey = GlobalKey<FormState>();

  late BuildContext _dialogContext;
  String? _itemSelecionadoEstado;
  String?  _itemSelecionadoCategoria;


  get arquivo => null;

  String get categoria => categoria;

  var _infiniteScrollController;


  // String? _itemSelecionadoEstado(String? value) {
  //   if (value == null) {
  //     // The user haven't typed anything
  //     return "Type something, man!";
  //   }
  //   if (value.length<2){
  //     return 'İsim en az iki karakter olmalıdır';
  //   }
  // }
// String? _itemSelecionadoEstado(String? value) {
//   if (value!.length < 6) {
//     return 'Invalid password, length must be more than 6';
//   }
// }
//   String? _itemSelecionadoCategoria(String? value) {
//     if(value!.length < 6){
//       return 'Invalid password, length must be more than 6';
//     }
// }
// String? _itemSelecionadoCategoria(String? value) {
//   if (value == null) {
//     // The user haven't typed anything
//     return "Type something, man!";
//   }
//   if (value.length<2){
//     return 'İsim en az iki karakter olmalıdır';
//   }
// }
  _selecionarImagemGaleria() async {
    var imagemSelecionada = await ImagePicker().pickImage(
        source: ImageSource.gallery) as File;
    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }
  _abrirDialog(BuildContext context){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio...")
              ],),
          );
        }
    );

  }
  _salvarAnuncio() async {
    _abrirDialog( _dialogContext );
    //Upload imagens no Storage
    await _uploadImagens();

//Salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
   User? usuarioLogado  = await FirebaseAuth.instance.currentUser;
   String idUsuarioLogado = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
        .doc( idUsuarioLogado )
        .collection("anuncios")
        .doc( _anuncio?.id)
        .set( _anuncio!.toMap() ).then((_) {
      //this.id = anuncios.doc(documentID).get as String;
      //salvar anúncio público
      db.collection("anuncios")
          .doc(_anuncio!.id)
          .set(_anuncio!.toMap()).then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });

    });


  }

  Future _uploadImagens() async {

    final storage = FirebaseStorage.instance;
    final storageRef = FirebaseStorage.instance.ref();

    for( var imagem in _listaImagens ){

      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      final imagesRef = storageRef
          .child("meus_anuncios")
          .child( _anuncio!.id )
          .child( nomeImagem );
      //StorageUploadTask
      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio?.fotos.add(url);

    }

  }


  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    Anuncio _anuncio;
  }
  _carregarItensDropdown(){

    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();

  }



  carregarItensDropdown(){

    //Categorias
    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Automóvel"), value: "auto",)
    );

    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Imóvel"), value: "imovel",)
    );

    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Eletrônicos"), value: "eletro",)
    );

    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Moda"), value: "moda",)
    );

    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Esportes"), value: "esportes",)
    );

  // //Estados
  // for( var estado in Estados.listaEstadosSigla ){
  //   _listaItensDropEstados.add(
  //       DropdownMenuItem(child: Text(estado), value: estado,)
  //   );
  // }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listaImagens,
                // validator: ( imagens ){
                //   if( imagens!.length == 0 ){
                //     return "Necessário selecionar uma imagem!";
                //   }
                //   return null;
                // },
                  builder: (state){
                    return Column(children: <Widget>[
                      Container(

                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1, //3
                            itemBuilder: (context, indice){
                              if( indice == _listaImagens.length ){
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                                color: Colors.grey[100]
                                            ),
                                          )
                                        ],),
                                    ),
                                  ),
                                );
                              }

                              if( _listaImagens.length > 0 ){
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Image.file( _listaImagens[indice] ),
                                                ElevatedButton(
                                                  child: Text("Excluir"),

                                                  onPressed: (){
                                                    setState(() {
                                                      _listaImagens.removeAt(indice);
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                )
                                              ],),
                                          )
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage( _listaImagens[indice] ),
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete, color: Colors.red,),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();

                            }
                        ),
                      ),
                      if( state.hasError )
                        Container(
                          child: Text(
                            "[${state.errorText}]",
                            style: TextStyle(
                                color: Colors.red, fontSize: 14
                            ),
                          ),
                        )
                    ],);
                  },
                ),

                Row(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: _itemSelecionadoEstado,
                        hint: Text("Estados"),
                       onSaved: (estado){
                      //   _formKey.currentState!.save();
                         _anuncio!.estado = estado!;
                      },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        items: _listaItensDropEstados,
                        validator: (valor){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                              .valido(valor);
                        },
                        onChanged: (valor){
                          setState(() {
                            _itemSelecionadoEstado = valor;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: _itemSelecionadoCategoria,
                        hint: Text("Categorias"),
                        onSaved: (categorias){

                          _anuncio?.categoria = categoria;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        items: _listaItensDropCategorias,
                        validator: (valor){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                              .valido(valor);
                        },
                        onChanged: (valor){
                          setState(() {
                            _itemSelecionadoCategoria = valor;
                          });
                        },
                      ),
                    ),
                  ),
                ],),

                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Título",
                    onSaved: (titulo){

                      _anuncio?.titulo = titulo;
                    },

                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    }, controller:_infiniteScrollController,
                    inputFormatters: [],
                    maxLines: 2,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Preço",
                   onSaved: (preco){
                     _anuncio?.preco = preco;

                   },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    type: TextInputType.number,
                    inputFormatters: [
                     // WhitelistingTextInputFormatter(RegExp("[a-z A-Z á-ú Á-Ú 0-9]")),
                      //RealInputFormatter()

                    ],
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    }, controller:_infiniteScrollController,
                    maxLines: 2,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Telefone",
                    onSaved: (telefone){
                     _anuncio?.telefone = telefone;

                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    type: TextInputType.phone,
                    inputFormatters: [
                      //WhitelistingTextInputFormatter.digitsOnly,
                      //TelefoneInputFormatter()
                    ],
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },controller:  _infiniteScrollController,
                    maxLines: 2,),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Descrição (200 caracteres)",
                    onSaved: (descricao){
                      _anuncio?.descricao = descricao;

                    },

                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    maxLines: 2,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(10, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    }, inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                  ], controller:  _infiniteScrollController,
                  ),
                ),

                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: (){
                    if( _formKey.currentState!.validate() ){

                      //salva campos
                      _formKey.currentState!.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar anuncio
                      _salvarAnuncio();

                    }
                  },
                ),
              ],),
          ),
        ),
      ),
    );
  }

}