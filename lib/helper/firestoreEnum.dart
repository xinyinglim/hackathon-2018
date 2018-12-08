import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreEnum<T> {
  //todo convert all Firestore enums to this
  Map<T, String> get enumToFirestore;
  Map<T, String> get enumToDisplay;
  T currentEnum;

  FirestoreEnum(this.currentEnum);

  T enumFromFirestoreString(String str) {
    enumToFirestore.forEach((T enumeration, String firestoreValue) {
      if (str == firestoreValue) {
        return enumeration;
      }
    });
    throw "Invalid Firestore string: cannot find corresponding enumeration";
  }

  String get firestoreString {
    String result = enumToFirestore[currentEnum];
    if (result == null) {
      throw "Invalid enumeration";
    }
    return result;
  }

  String get displayString {
    String result = enumToDisplay[currentEnum];
    if (result == null) {
      throw "Invalid enumeration";
    }
    return result;
  }

  T initializeFirestoreStringIfValid(String firestoreString) {
    enumToFirestore.forEach((T enumeration, String firestoreValue) {
      if (firestoreString == firestoreValue) return enumeration;
    });
    return null;
  }
  //get firestoreString, //getdisplayString
//factory from firesotre,
}