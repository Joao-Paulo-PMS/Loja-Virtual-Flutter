import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_b/views/Anuncios.dart';
import 'package:loja_virtual_b/views/DetalhesAnuncio.dart';
import 'package:loja_virtual_b/views/Login.dart';
import 'package:loja_virtual_b/views/MeusAnuncios.dart';
import 'package:loja_virtual_b/views/NovoAnuncio.dart';

import 'models/Anuncio.dart';


class RouteGenerator {
  Anuncio anuncio;


  RouteGenerator(this.anuncio);

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch( settings.name ) {
      case "/" :
        return MaterialPageRoute(
            builder: (_) => Anuncios()
        );
      case "/login" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/meus-anuncios" :
        return MaterialPageRoute(
            builder: (_) => MeusAnuncios()
        );
      case "/novo-anuncio" :
        return MaterialPageRoute(
            builder: (_) => NovoAnuncio()
        );
      case "/detalhes-anuncio" :
        return MaterialPageRoute(
            builder: (_) => DetalhesAnuncio()
        );
      default:
        _erroRota();
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );

    }

  }



  static Route<dynamic> _erroRota(){

    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(
              title: Text("Tela não encontrada!"),
            ),
            body: Center(
              child: Text("Tela não encontrada!"),
            ),
          );
        }
    );

  }

}