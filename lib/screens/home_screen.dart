import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluterappfirebase/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? _currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> _getUserGit() async {
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

  Future<User?> _getUser() async {
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
                User? user = await _getUser();
                if (user != null) {
                  print("Usuário logado com o Google: ${user.displayName}");
                  Navigator.of(context).pushNamed('/chat'); // Redirecionar para a tela de chat
                }
              },
              icon: Image.asset("assets/google_icon.png", height: 24), // Ícone do Google
              label: Text("Sign in with Google"),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                User? user = await _getUserGit();
                if (user != null) {
                  print("Usuário logado com o GitHub: ${user.email}");
                  Navigator.of(context).pushNamed('/chat'); // Redirecionar para a tela de chat
                }
              },
              icon: Image.asset("assets/github_icon.png", height: 24), // Ícone do GitHub
              label: Text("Sign in with GitHub"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white), // Fundo branco
                foregroundColor: MaterialStateProperty.all(Colors.black), // Texto preto
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/lista');
              },
              icon: Image.asset("assets/marcador_icon.png", height: 24), // Ícone do GitHub
              label: Text("Adicionar Locais"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red), // Fundo branco
                foregroundColor: MaterialStateProperty.all(Colors.white), // Texto preto
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pushNamed('/map');
              },
              icon: Image.asset("assets/maps_icon.png", height: 24), // Ícone do GitHub
              label: Text("Google Maps"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green), // Fundo branco
                foregroundColor: MaterialStateProperty.all(Colors.white), // Texto preto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
