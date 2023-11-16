import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluterappfirebase/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/chat');
              },
              icon: Image.asset("assets/chat_icon.png", height: 32),
              label: Text(
                "Chat",
                style: TextStyle(fontSize: 25), // Ajuste o tamanho do texto conforme necessário
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                fixedSize: MaterialStateProperty.all(Size(300, 50)),
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/lista');
              },
              icon: Image.asset("assets/marcador_icon.png", height: 32),
              label: Text(
                "Adicionar Locais",
                style: TextStyle(fontSize: 25), // Ajuste o tamanho do texto conforme necessário
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                fixedSize: MaterialStateProperty.all(Size(300, 50)),
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/map');
              },
              icon: Image.asset("assets/maps_icon.png", height: 32),
              label: Text(
                "Google Maps",
                style: TextStyle(fontSize: 25), // Ajuste o tamanho do texto conforme necessário
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                fixedSize: MaterialStateProperty.all(Size(300, 50)),
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/textRecognition');
              },
              icon: Image.asset("assets/text_recognition_icon.png", height: 32),
              label: Text(
                "Text Recognition",
                style: TextStyle(fontSize: 25), // Ajuste o tamanho do texto conforme necessário
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                fixedSize: MaterialStateProperty.all(Size(300, 50)),
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/imageLabeling');
              },
              icon: Image.asset("assets/image_labeling_icon.png", height: 32),
              label: Text(
                "Image Labeling",
                style: TextStyle(fontSize: 25), // Ajuste o tamanho do texto conforme necessário
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                fixedSize: MaterialStateProperty.all(Size(300, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
