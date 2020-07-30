import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/src/pages/signinpage.dart';
import 'package:agora_flutter_quickstart/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _auth.getCurrentFirebaseUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return IndexPage();
          } else {
            return SignInPage();
          }
        });
  }
}
