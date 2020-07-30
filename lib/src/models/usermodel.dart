class registeredUser {
  final String phoneNumber;
  final String userToken;

  registeredUser({this.phoneNumber, this.userToken});
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'userToken': userToken,
    };
  }

  registeredUser.fromFirestore(Map<String, dynamic> firestore)
      : phoneNumber = firestore['phoneNUmber'],
        userToken = firestore['userToken'];
}
