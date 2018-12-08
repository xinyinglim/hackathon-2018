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
class Address {
  String line1FS = "line1";
  String line2FS = "line2";
  String kampungFS = "kampung";
  String districtFS = "district";
  String countryFS = "country";
  String geoPointFS = "geoPoint";

  String line1;
  String line2; //optional
  String kampung;
  String district;
  String country;
  GeoPoint geoPoint;

  Address();

  Address.fromMap(Map<String, dynamic> map){
    this.line1 = map[line1FS];
    this.line2 = map[line2FS] ?? "";
    this.kampung = map[kampungFS];//todo Kampung should be enum
    this.district = map[districtFS];
    this.country = map[countryFS];
    this.geoPoint = map[geoPointFS];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      line1FS : line1,
      kampungFS : kampung,
      districtFS : district,
      countryFS : country,
      geoPointFS : geoPoint,
    };
    if (line2 != "") map.addAll({line2FS : line2});
    return map;
  }
}

class Driver {
  static String driverIDFS = "driverID";
  static String nameFS = "name";
  static String currentLocationFS = "currentLocation";
  static String activeFS = "active";

  DocumentReference ref; //todo add to everything
  String driverID;
  String name;
  GeoPoint currentLocation; //only available if you are on activeDuty
  bool active;
  //bool busy/oncall
  //todo connect to user id

  Driver.fromDocumentSnapshot(DocumentSnapshot snap){
    ref = snap.reference;
    Map<String, dynamic> result = snap.data;
    this.driverID = result[driverIDFS];
    this.name = result[nameFS];
    this.currentLocation = result[currentLocationFS];
    this.active = result[activeFS];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      driverIDFS : this.driverID,
      nameFS : this.name,
      currentLocationFS : this.currentLocation,
      activeFS : this.active,
    };
    return result;

  }

}

class User {
  static CollectionReference colRef = Firestore.instance.collection("users");
  String id;  //id is a string, and you can tell others your id and they can find you and use your home address. Assume immutable
  String name;
  // bool activeDriver;
  Address homeAddress;

  static String idFS = "id";
  static String homeAddressFS = "homeAddress";
  static String nameFS = "name";
  // static String activeDriverFS = "activeDriver";

  User();

  Future<void> createInFirestore() async {
    if (this.id == null) throw ArgumentError("No id found");
    colRef.document(this.id).setData(this.toMap());
  }

  Map<String, dynamic> toMap() => {
    idFS : this.id,
    nameFS : this.name,
    // activeDriverFS : this.activeDriver,
    homeAddressFS : this.homeAddress?.toMap(),
  };

  User.fromDocumentSnapshot (DocumentSnapshot snap){
    Map<String, dynamic> raw = snap.data;
    this.id = raw[idFS];
    this.homeAddress = Address.fromMap(raw[homeAddressFS].cast<String, dynamic>());
    this.name = raw[nameFS];
    // this.activeDriver = raw[activeDriverFS];
  }
}

enum DeliveryStatus {FindingDrivers, AwaitingPickup, OnItsWay, Delivered, Cancelled}

class DeliveryStatusEnum extends FirestoreEnum<DeliveryStatus> {

  @override
  Map<DeliveryStatus, String> get enumToFirestore => {
    DeliveryStatus.FindingDrivers : "findingDrivers",
    DeliveryStatus.AwaitingPickup : "awaitingPickup",
    DeliveryStatus.OnItsWay : "onItsWay",
    DeliveryStatus.Delivered : "delivered",
    DeliveryStatus.Cancelled : "cancelled",
  };

  @override
  Map<DeliveryStatus,String> get enumToDisplay => {
    DeliveryStatus.FindingDrivers : "Finding Drivers",
    DeliveryStatus.AwaitingPickup : "Awaiting Pickup",
    DeliveryStatus.OnItsWay : "On its way",
    DeliveryStatus.Delivered : "Delivered",
    DeliveryStatus.Cancelled : "cancelled",
  };

  DeliveryStatusEnum.fromFirestoreString(String str):super(null){
    this.currentEnum = enumFromFirestoreString(str);
  }
}

class DeliveryRequest {
  static String deliveryIDFS = "deliveryID";
  static String driverIDFS = "driverID";
  static String senderIDFS = "senderID";
  static String recipientConfirmationCodeFS = "recipientConfirmationCode";
  static String parcelIDFS = "parcelID";
  static String requestedArrivalTimeFS = "requestedArrivalTime";
  static String estimatedArrivalTimeFS = "estimatedArrivalTime";
  static String actualArrivalTimeFS = "actualArrivalTime";
  static String estimatedPickupTimeFS = "actualPickupTime";
  static String actualPickupTimeFS = "actualPickupTime";
  static String deliveryStatusEnumFS = "deliveryStatusEnum";

  DocumentReference ref;
  String deliveryID;
  String driverID;
  String senderID;
  String recipientConfirmationCode;
  String parcelID;
  DateTime requestedArrivalTime;  //customer can request when they want it
  DateTime estimatedArrivalTime; //customer is given notice when it will arrive
  DateTime actualArrivalTime;
  DateTime estimatedPickupTime;
  DateTime actualPickupTime;
  DeliveryStatusEnum deliveryStatusEnum;

  DeliveryRequest.fromDocumentSnapshot(DocumentSnapshot snap){
    this.ref = snap.reference;
    Map<String, dynamic> map = snap.data;
    this.deliveryID = map[deliveryIDFS];
    this.driverID = map[driverIDFS];
    this.senderID = map[senderIDFS];
    this.recipientConfirmationCode = map[recipientConfirmationCodeFS];
    this.parcelID = map[parcelIDFS];
    this.requestedArrivalTime = (map[requestedArrivalTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[requestedArrivalTimeFS].toString()));
    this.estimatedArrivalTime = (map[estimatedArrivalTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[estimatedArrivalTimeFS].toString()));
    this.actualArrivalTime = (map[actualArrivalTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[actualArrivalTimeFS].toString()));
    this.estimatedPickupTime = (map[estimatedPickupTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[estimatedPickupTimeFS].toString()));
    this.actualPickupTime = (map[actualPickupTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[actualPickupTimeFS].toString()));
    //todo null should not be an option in production code
    this.deliveryStatusEnum = DeliveryStatusEnum.fromFirestoreString(map[deliveryStatusEnum]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      deliveryIDFS : deliveryID,
      driverIDFS : driverID,
      senderIDFS : senderID,
      recipientConfirmationCodeFS : recipientConfirmationCode,
      parcelIDFS : parcelID,
    };
    if (this.requestedArrivalTime != null) result.addAll({requestedArrivalTimeFS : this.requestedArrivalTime.millisecondsSinceEpoch});
      if (this.estimatedArrivalTime != null) result.addAll({estimatedArrivalTimeFS : this.estimatedArrivalTime.millisecondsSinceEpoch});
    if (this.actualArrivalTime != null) result.addAll({actualArrivalTimeFS : this.actualArrivalTime.millisecondsSinceEpoch});
    if (this.estimatedPickupTime != null) result.addAll({estimatedPickupTimeFS : this.estimatedPickupTime.millisecondsSinceEpoch});
    if (this.actualPickupTime != null) result.addAll({actualPickupTimeFS : this.actualPickupTime.millisecondsSinceEpoch});
    return result;
  }
}

class Parcel {
  static String parcelIDFS = "parcelID";
  static String senderIDFS = "senderID";
  static String sizeFS = "size";
  static String typeFS = "type";

  DocumentReference ref;
  String parcelID;
  String senderID;//redirects to a user
  String size;
  String type; 

  Parcel.fromDocumentSnapshot(DocumentSnapshot snap){
    this.ref = snap.reference;
    Map<String, dynamic> map = snap.data;
    this.parcelID = map[parcelIDFS];
    this.senderID = map[senderIDFS];
    this.size = map[sizeFS];
    this.type = map[typeFS];
  }

  Map<String, dynamic> toMap() {
    return {
      parcelIDFS : this.parcelID,
      senderIDFS : this.senderID,
      sizeFS : this.size,
      type : this.type,
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
  Address homeAddress;//includes the geopoint
  String phoneNumber;
  // Address workAddress;
  String creatorID;
  
  Map<String, dynamic> toMap() => {
    recipientIDFS : this.recipientID,
    nameFS : this.name,
    homeAddressFS : homeAddress.toMap(),
    phoneNumberFS : this.phoneNumber,
    creatorIDFS : this.creatorID,
  };

  Recipient.fromDocumentSnapshot(DocumentSnapshot snap){
    Map<String, dynamic> map = snap.data;
    ref = snap.reference;
    this.recipientID = map[recipientIDFS];
    this.name = map[nameFS];
    this.homeAddress = Address.fromMap(map[homeAddressFS].cast<String,dynamic>());
    this.phoneNumber = map[phoneNumberFS];
    this.creatorID = map[creatorIDFS];
  }

}//needed for the frequently used contacts of a user, might not have an account. If it does have an account, will auto sync
//don't need to implement above, not flashy enough