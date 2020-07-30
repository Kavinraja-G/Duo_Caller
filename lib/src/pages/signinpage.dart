import 'dart:async';

import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phnoController = TextEditingController();

  final TextEditingController _verificationCodeController =
      TextEditingController();

  // ignore: missing_return
  Future<bool> loginUser(String number, BuildContext context) async {
    final auth = Provider.of<BaseAuthentication>(context, listen: false);
    // ignore: omit_local_variable_types
    FirebaseAuth _auth = auth.getAuth();
    await _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          // ignore: omit_local_variable_types
          AuthResult result = await _auth.signInWithCredential(credential);
          // ignore: omit_local_variable_types
          FirebaseUser user = result.user;
          if (user != null) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IndexPage(number)),
            );
          } else {
            print('Error Occured');
          }
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationCode, [int resendToken]) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Code Recieved?'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _verificationCodeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Confirm'),
                      color: Colors.black,
                      onPressed: () async {
                        final insertedCode =
                            _verificationCodeController.text.trim();
                        // ignore: omit_local_variable_types
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationCode,
                                smsCode: insertedCode);
                        // ignore: omit_local_variable_types
                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        // ignore: omit_local_variable_types
                        FirebaseUser user = result.user;
                        if (user != null) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndexPage(number),
                              ));
                        } else {
                          print('Error Occured');
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/loginbg.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 30.0,
                        offset: Offset(0, 5),
                      )
                    ]),
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _phnoController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 125, right: 125),
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  final number = _phnoController.text.trim();
                  loginUser(number, context);
                },
                icon: Icon(Icons.play_arrow),
                label: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
