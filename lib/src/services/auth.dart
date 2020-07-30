import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;
  User({@required this.uid});
}

abstract class BaseAuthentication {
  Stream<User> get onAuthStateChanged;
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<User> currentUser();
  Future<String> currentUserUID();
  Future<String> getPhoneNumber();
  Stream<FirebaseUser> get currentFirebaseUser;
  FirebaseAuth getAuth();
}

class Auth implements BaseAuthentication {
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged
        .map((event) => _userFromFirebase(event));
  }

  @override
  Future<User> signInAnonymously() async {
    final result = await FirebaseAuth.instance.signInAnonymously();
    return _userFromFirebase(result.user);
  }

  //Google SignIn
  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Tokens');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORT_BY_USER', message: 'Sign in was Aborted');
    }
  }

  @override
  Future<void> signOut() async {
    final googleAccount = GoogleSignIn();
    await googleAccount.signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<User> currentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<String> currentUserUID() async {
    final user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  @override
  Stream<FirebaseUser> get currentFirebaseUser {
    return FirebaseAuth.instance.onAuthStateChanged.map((event) => (event));
  }

  @override
  FirebaseAuth getAuth() {
    return FirebaseAuth.instance;
  }

  @override
  Future<String> getPhoneNumber() async {
    final user = await FirebaseAuth.instance.currentUser();
    return user.phoneNumber;
  }
}
