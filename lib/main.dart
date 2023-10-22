import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluterappfirebase/screens/chat_screen.dart';
import 'package:fluterappfirebase/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // criando uma referência para uma coleção no firestore
  final CollectionReference _contato =
  FirebaseFirestore.instance.collection("contatos");

  //_contato.add({"nome" : "Maria", "fone" : "222222"});

  //_contato.doc('HCWZKeYEQWOODJKtn6vo').update(
  //    {'fone':'555555', 'idade' :'34' });

  //_contato.doc('HCWZKeYEQWOODJKtn6vo').delete();

  //QuerySnapshot snapshot = await _contato.get();

  //snapshot.docs.forEach((doc) {
  //  print(doc.data().toString());
  //});

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //home: ChatScreen(),
      home: HomeScreen(),
      routes: {
        '/chat': (context) => ChatScreen(), // Rota para a tela de chat
      },
    );
  }
}