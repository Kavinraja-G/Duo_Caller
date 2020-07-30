import 'dart:async';
import 'package:agora_flutter_quickstart/src/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final Firestore _db = Firestore.instance;
  // ignore: missing_return
  Future<void> saveRegisteredUser(registeredUser regUser) {
    if (_db.collection('user').document().documentID != regUser.phoneNumber) {
      return _db
          .collection('user')
          .document(regUser.phoneNumber)
          .setData(regUser.toMap());
    }
  }

  Future<bool> checkForPhoneNumber(String number) async {
    var docRef = await _db.collection('user').document(number).get();
    if (docRef == null || !docRef.exists) {
      return false;
    }
    return true;
  }
}
