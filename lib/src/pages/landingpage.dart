import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/src/pages/signinpage.dart';
import 'package:agora_flutter_quickstart/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: _auth.currentFirebaseUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // ignore: omit_local_variable_types
            FirebaseUser user = snapshot.data;
            if (user != null) {
              return IndexPage(user.phoneNumber);
            } else {
              return SignInPage();
            }
          } else {
            return Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        });
  }
}
