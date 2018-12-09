import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:hackathon_test/helper/address.dart';

class User {
  static CollectionReference colRef = Firestore.instance.collection("users");
  String
      id; //id is a string, and you can tell others your id and they can find you and use your home address. Assume immutable
  String name;
  // bool activeDriver;
  Address homeAddress;
  String email;

  static String idFS = "id";
  static String homeAddressFS = "homeAddress";
  static String nameFS = "name";
  static String emailFS = "email";
  // static String activeDriverFS = "activeDriver";

  User();

  User.data(this.id, this.homeAddress, this.name, this.email);

  Future<void> createInFirestore() async {
    if (this.id == null) throw ArgumentError("No id found");
    colRef.document(this.id).setData(this.toMap());
  }

  Map<String, dynamic> toMap() => {
        idFS: this.id,
        nameFS: this.name,
        // activeDriverFS : this.activeDriver,
        homeAddressFS: this.homeAddress?.toMap(),
        emailFS: this.email,
      };

  User.fromDocumentSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> raw = snap.data;
    this.id = raw[idFS];
    this.homeAddress =
        Address.fromMap(raw[homeAddressFS].cast<String, dynamic>());
    this.name = raw[nameFS];
    this.email = raw[emailFS];
    // this.activeDriver = raw[activeDriverFS];
  }
}

class Parcel {
  static String parcelIDFS = "parcelID";
  static String senderIDFS = "senderID";
  static String sizeFS = "size";
  static String typeFS = "type";

  DocumentReference ref;
  String parcelID;
  String senderID; //redirects to a user
  String size;
  String type;

  Parcel.fromDocumentSnapshot(DocumentSnapshot snap) {
    this.ref = snap.reference;
    Map<String, dynamic> map = snap.data;
    this.parcelID = map[parcelIDFS];
    this.senderID = map[senderIDFS];
    this.size = map[sizeFS];
    this.type = map[typeFS];
  }

  Map<String, dynamic> toMap() {
    return {
      parcelIDFS: this.parcelID,
      senderIDFS: this.senderID,
      sizeFS: this.size,
      type: this.type,
    };
  }
}

class Recipient {
  static String recipientIDFS = "recipientID";
  static String nameFS = "name";
  static String homeAddressFS = "homeAddress";
  static String phoneNumberFS = "phoneNumber";
  static String creatorIDFS = "creatorID";

  DocumentReference ref;
  String recipientID;
  String name;
  Address homeAddress; //includes the geopoint
  String phoneNumber;
  // Address workAddress;
  String creatorID;

  Map<String, dynamic> toMap() => {
        recipientIDFS: this.recipientID,
        nameFS: this.name,
        homeAddressFS: homeAddress.toMap(),
        phoneNumberFS: this.phoneNumber,
        creatorIDFS: this.creatorID,
      };

  Recipient.fromDocumentSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> map = snap.data;
    ref = snap.reference;
    this.recipientID = map[recipientIDFS];
    this.name = map[nameFS];
    this.homeAddress =
        Address.fromMap(map[homeAddressFS].cast<String, dynamic>());
    this.phoneNumber = map[phoneNumberFS];
    this.creatorID = map[creatorIDFS];
  }
} //needed for the frequently used contacts of a user, might not have an account. If it does have an account, will auto sync
//don't need to implement above, not flashy enough
