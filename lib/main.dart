import 'package:flutter/material.dart';
import 'package:loja_virtual_b/views/home.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff9c27b0)

);

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MaterialApp(
      title: "Loja virtual",
      home: Home(),
      theme: temaPadrao,
      debugShowCheckedModeBanner: false,
    ));

}
