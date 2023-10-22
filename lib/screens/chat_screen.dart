import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? _currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  bool _isLoading = false;

  final CollectionReference _mensagens =
  FirebaseFirestore.instance.collection("mensagens");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _mensagens.orderBy("time").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        List<DocumentSnapshot> documents =
                        snapshot!.data!.docs.reversed.toList();
                        return ListView.builder(
                            itemCount: documents.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            documents[index].get('url') != ""
                                                ? Image.network(
                                                documents[index].get('url'),
                                                width: 150)
                                                : Text(
                                              documents[index].get('text'),
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              );
                            });
                    }
                  },
                )),
            TextComposer(_sendMessage),
          ],
        ));
  }

  void _sendMessage({String? text, XFile? imgFile}) async {
    //User? user = await _getUser(context: context);
    //User? user = await _getUserGit(context: context);

    Map<String, dynamic> data = {
      'url': "",
      'time': Timestamp.now(),
    };

    if (imgFile != null) {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("imgs")
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final metadados = firebase_storage.SettableMetadata(
          contentType: "image/jpeg",
          customMetadata: {"picked-file-path": imgFile.path});
      if (kIsWeb) {
        uploadTask = ref.putData(await imgFile.readAsBytes(), metadados);
      } else {
        uploadTask = ref.putFile(File(imgFile.path));
      }
      var taskSnapshot = await uploadTask;
      String imageUrl = "";
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      data['url'] = imageUrl;
    } else {
      data["text"] = text;
    }
    _mensagens.add(data);
  }

  Future<User?> _getUserGit({required BuildContext context}) async {
    User? user;
    if (_currentUser != null) return _currentUser;

    if (kIsWeb) {
      //WEB
      GithubAuthProvider githubProvider = GithubAuthProvider();
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(githubProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      //ANDROID
      GithubAuthProvider githubProvider = GithubAuthProvider();
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(githubProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    }
    print("User logado:"+user!.email.toString());
    return user;
  }

  Future<User?> _getUser({required BuildContext context}) async {
    User? user;
    if (_currentUser != null) return _currentUser;
    if (kIsWeb) {
      //WEB
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      //ANDROID
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);
          user = userCredential.user;
        } catch (e) { print(e); }
      }
    }
    print("user logado: " + user!.displayName.toString());
    return user;
  }

}
