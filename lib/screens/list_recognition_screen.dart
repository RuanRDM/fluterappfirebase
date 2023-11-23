import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'mapa_screen.dart';
import 'package:fluterappfirebase/screens/mapa_screen.dart';

class ListaTextos extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ListaTextosState();
  }
}

class ListaTextosState extends State<ListaTextos>{
  final CollectionReference _locais =
  FirebaseFirestore.instance.collection("textos");

  _abrirMapa(String idLocal){
    Navigator.push(context, MaterialPageRoute(builder: (_) =>
        MapSample(idLocal : idLocal)));
  }
  _adicionarLocal(){
    Navigator.push(context, MaterialPageRoute(builder: (_) =>
        MapSample()));
  }

  _excluirLocal(String idLocal){
    _locais.doc(idLocal).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Textos"),),
      body: StreamBuilder<QuerySnapshot>(
        stream: _locais.snapshots(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              List<DocumentSnapshot> locais = [];
              var querySnapshot = snapshot.data;
              if (querySnapshot != null) {
                locais = querySnapshot.docs.toList();
              }
              return Column(
                children: <Widget>[
                  Expanded(child: ListView.builder(
                    itemCount: locais.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot item = locais[index];
                      String titulo = item['text'];
                      String idLocal = item.id;
                      return GestureDetector(
                        child: Card(
                          child: ListTile(
                            title: Text(titulo),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    _excluirLocal(idLocal);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                        Icons.remove_circle,
                                        color : Colors.red
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ))
                ],
              );
          }
        },
      ),
    );
  }
}