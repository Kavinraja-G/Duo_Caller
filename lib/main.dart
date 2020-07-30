import 'package:agora_flutter_quickstart/src/pages/landingpage.dart';
import 'package:agora_flutter_quickstart/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _auth = Auth();
    return Provider<BaseAuthentication>(
      create: (context) => _auth,
        child: MaterialApp(
        title: 'Flutter Demo',
        home: LandingPage(),
      ),
    );
  }
}
