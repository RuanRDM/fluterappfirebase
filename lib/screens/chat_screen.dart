import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class ChatScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen>{
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: TextComposer(_sendMessage),
    );
  }

  void _sendMessage({String? text, XFile? imgFile}) async{
    final CollectionReference _mensagens =
        FirebaseFirestore.instance.collection("mensagens");

    Map<String, dynamic> data = {
      'url': "",
      'time': Timestamp.now(),
    };

    if(imgFile != null){
      firebase_storage.UploadTask uploadtask;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance
      .ref()
      .child("imgs")
      .child(DateTime.now().millisecondsSinceEpoch.toString());
      final metadados = firebase_storage.SettableMetadata(
        contentType: "image/jpeg",
        customMetadata: {"picked-file-path": imgFile.path}
      );
      if (kIsWeb){
        uploadtask = ref.putData(await imgFile.readAsBytes(), metadados);
      }else{
        uploadtask = ref.putFile(File(imgFile.path));
      }
      var taskSnapshot = await uploadtask;
      String imageUrl = "";
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      data['url']= imageUrl;
    }else{
      data['text'] = text;
    }
    _mensagens.add(data);
  }
}